#!/usr/bin/env python3
"""App Store Connect API 用の短命 JWT（ES256）を生成して標準出力に印字する。

App Store Connect API は Apple ID ではなく、.p8 秘密鍵で署名した JWT で認証する。
このスクリプトは .env（または環境変数）の以下を読み取る:

    ASC_KEY_ID              10 桁の Key ID
    ASC_ISSUER_ID           Issuer ID（UUID）
    ASC_KEY_PATH            AuthKey_XXXXXXXXXX.p8 のパス
    ASC_KEY_CONTENT_BASE64  .p8 の中身を base64 化した文字列（CI 用、PATH より優先）

依存: PyJWT と cryptography
    pip install "pyjwt[crypto]"

使い方:
    python3 scripts/asc_token.py                 # トークンを表示
    export TOKEN=$(python3 scripts/asc_token.py) # 変数に格納
"""
from __future__ import annotations

import base64
import os
import sys
import time

try:
    import jwt  # PyJWT
except ImportError:  # pragma: no cover
    sys.exit('PyJWT が必要です: pip install "pyjwt[crypto]"')


def _load_env_file(path: str = ".env") -> None:
    """簡易 .env ローダー（依存を増やさないため自前実装）。"""
    if not os.path.exists(path):
        return
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            os.environ.setdefault(key.strip(), value.strip())


def _private_key() -> str:
    content_b64 = os.environ.get("ASC_KEY_CONTENT_BASE64", "").strip()
    if content_b64:
        return base64.b64decode(content_b64).decode("utf-8")

    key_path = os.environ.get("ASC_KEY_PATH", "").strip()
    if key_path and os.path.exists(key_path):
        with open(key_path, encoding="utf-8") as f:
            return f.read()

    sys.exit("秘密鍵が見つかりません。ASC_KEY_PATH か ASC_KEY_CONTENT_BASE64 を設定してください。")


def generate_token() -> str:
    key_id = os.environ.get("ASC_KEY_ID", "").strip()
    issuer_id = os.environ.get("ASC_ISSUER_ID", "").strip()
    if not key_id or not issuer_id:
        sys.exit("ASC_KEY_ID と ASC_ISSUER_ID を設定してください。")

    now = int(time.time())
    payload = {
        "iss": issuer_id,
        "iat": now,
        "exp": now + 60 * 19,  # ASC の JWT 上限は 20 分。余裕を持って 19 分。
        "aud": "appstoreconnect-v1",
    }
    headers = {"kid": key_id, "typ": "JWT"}
    return jwt.encode(payload, _private_key(), algorithm="ES256", headers=headers)


if __name__ == "__main__":
    _load_env_file()
    print(generate_token())
