#!/usr/bin/env bash
# App Store Connect API を叩く簡易ヘルパー。
#
# .env を読み込み、scripts/asc_token.py で生成した JWT を使って
# App Store Connect API v1 にリクエストする。
#
# 使い方:
#   scripts/asc_api.sh apps                 # 自分の App 一覧
#   scripts/asc_api.sh iaps <APP_ID>        # 指定 App のアプリ内課金一覧
#   scripts/asc_api.sh get /v1/apps         # 任意エンドポイントを GET
#
# `asc` CLI（https://github.com/aaronsky/asc）を使う場合は、同じ .env の
# ASC_KEY_ID / ASC_ISSUER_ID / ASC_KEY_PATH をそのまま流用できる。例:
#   asc --key-id "$ASC_KEY_ID" --issuer-id "$ASC_ISSUER_ID" \
#       --private-key "$(cat "$ASC_KEY_PATH")" apps list
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
API="https://api.appstoreconnect.apple.com"

# .env を読み込む
if [[ -f "$ROOT_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
  set +a
fi

TOKEN="$(python3 "$ROOT_DIR/scripts/asc_token.py")"

_get() {
  curl -sS -H "Authorization: Bearer $TOKEN" "$API$1"
}

cmd="${1:-}"
case "$cmd" in
  apps)
    _get "/v1/apps?limit=200"
    ;;
  iaps)
    app_id="${2:?APP_ID を指定してください}"
    _get "/v1/apps/$app_id/inAppPurchasesV2?limit=200"
    ;;
  get)
    path="${2:?パスを指定してください（例: /v1/apps）}"
    _get "$path"
    ;;
  token)
    echo "$TOKEN"
    ;;
  *)
    echo "usage: $0 {apps|iaps <APP_ID>|get <path>|token}" >&2
    exit 1
    ;;
esac
