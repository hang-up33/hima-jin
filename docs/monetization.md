# 課金 & App Store Connect API セットアップガイド

ヒマジンに RevenueCat による課金（**ヒマジンPro**）と、App Store Connect API を
使ったビルド配信・課金商品管理を導入するための手順書です。
[Shipaton](https://jp.shipaton.com)（RevenueCat 主催ハッカソン）への提出を想定しています。

---

## 1. アーキテクチャ概要

```
Flutter アプリ
├─ core/config/revenuecat_config.dart   … SDK キー・Entitlement ID（dart-define 注入）
├─ data/repositories/purchase_repository.dart … RevenueCat SDK ラッパー
├─ presentation/providers/purchase_providers.dart … isPro / 顧客情報（Riverpod）
└─ presentation/screens/paywall/paywall_screen.dart … ペイウォール UI

ツール（App Store Connect API）
├─ fastlane/                … TestFlight / App Store 配信（ASC API キー認証）
├─ scripts/asc_token.py     … ASC API 用 JWT 生成
├─ scripts/asc_api.sh       … ASC API 呼び出しヘルパー（apps / iaps ...）
└─ .github/workflows/ios-testflight.yml … CI 配信
```

**課金モデル**: ヒマジンPro（サブスク/買い切り）を購入すると、Pro 限定実績パック
（`kProAchievementCount` 種、`lib/core/constants/achievements_data.dart` の `isPro: true`）が
解放されます。`pro` Entitlement の有効/無効で `isProProvider` が切り替わり、
未加入では該当実績が👑ロック表示になります。

> キー未設定のビルドでは RevenueCat 初期化をスキップし、アプリは無料モードで
> 通常どおり動作します（テスト・CI・レビューが壊れません）。

---

## 2. RevenueCat ダッシュボード設定

1. [RevenueCat](https://app.revenuecat.com/) でプロジェクトを作成し、iOS アプリを追加。
   - **App Bundle ID**: `com.himajin.himaJin`
2. **Entitlements** で `pro` を作成（コードの `RevenueCatConfig.entitlementPro` と一致）。
3. **Products** に、後述の App Store Connect の課金商品を登録し、`pro` Entitlement に紐づける。
4. **Offerings** で `default` を作成し、各 Package（monthly / lifetime など）を追加。
   - コードは `default` を優先し、無ければ `current` にフォールバックします。
5. **API keys** → *Public app-specific key*（`appl_...`）を控える → `.env` の `REVENUECAT_IOS_API_KEY` へ。

---

## 3. App Store Connect の課金商品

App Store Connect > マイApp > ヒマジン > 「アプリ内課金」「サブスクリプション」で作成します。
Product ID は RevenueCat の Product に登録するものと一致させます（推奨値）:

| 種別 | Product ID | 参照名 |
| --- | --- | --- |
| 自動更新サブスク（月額） | `com.himajin.himajin.pro.monthly` | ヒマジンPro 月額 |
| 非消耗型（買い切り） | `com.himajin.himajin.pro.lifetime` | ヒマジンPro 買い切り |

作成後、審査提出時にレビュー情報とスクリーンショットが必要です。

---

## 4. App Store Connect API キーの発行

1. App Store Connect > **ユーザーとアクセス** > **統合** > **App Store Connect API**。
2. チームキーを生成し、次を控える:
   - **Key ID**（10 桁）→ `ASC_KEY_ID`
   - **Issuer ID**（UUID）→ `ASC_ISSUER_ID`
   - **AuthKey_XXXXXXXXXX.p8**（ダウンロードは一度きり）→ プロジェクト直下に配置し `ASC_KEY_PATH` に指定
3. `.p8` は**絶対にコミットしない**（`.gitignore` 済み）。CI では base64 化して Secrets に登録:
   ```sh
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy   # → ASC_KEY_CONTENT_BASE64
   ```

---

## 5. 環境変数の設定

```sh
cp .env.example .env
# .env を編集して各値を設定
```

`.env` の主なキー: `REVENUECAT_IOS_API_KEY`, `ASC_KEY_ID`, `ASC_ISSUER_ID`,
`ASC_KEY_PATH`（詳細は `.env.example`）。

GitHub Actions の TestFlight 配信では、`testflight` Environment を作成し、承認ルールと
`ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT_BASE64`, `REVENUECAT_IOS_API_KEY`,
`DEVELOPER_TEAM_ID`, `IOS_CERTIFICATE_BASE64`, `IOS_CERTIFICATE_PASSWORD`,
`IOS_PROVISION_PROFILE_BASE64`, `KEYCHAIN_PASSWORD` を Environment Secrets に登録します。

---

## 6. ローカルで動かす

```sh
make setup          # flutter pub get（＋ bundle install）

# 無料モードで起動（キー不要）
make run

# RevenueCat キーを注入して課金を有効化して起動
make pro-run
# 直接指定する場合:
flutter run --dart-define=REVENUECAT_IOS_API_KEY=appl_xxxxxxxx
```

App Store の Sandbox テスターでの購入テストは、実機 + TestFlight もしくは
Xcode の StoreKit 構成で行います。

---

## 7. App Store Connect API を叩く

### fastlane で疎通確認 & 配信
```sh
make asc-verify     # API キーの疎通と最新 TestFlight ビルド番号を表示
make beta           # flutter build ipa → TestFlight アップロード
make release        # App Store 審査提出用にアップロード
```

### 生の API を叩く（JWT + curl）
```sh
make asc-apps                       # App 一覧
./scripts/asc_api.sh iaps <APP_ID>  # 指定 App の課金商品一覧
./scripts/asc_api.sh get /v1/apps   # 任意エンドポイント
make asc-token                      # 短命 JWT を生成（PyJWT 必要）
```
> `scripts/asc_token.py` は `pip install "pyjwt[crypto]"` が必要です。

### `asc` CLI を使う場合
[`asc`](https://github.com/aaronsky/asc) CLI を使うなら、同じ `.env` の値を流用できます:
```sh
asc --key-id "$ASC_KEY_ID" --issuer-id "$ASC_ISSUER_ID" \
    --private-key "$(cat "$ASC_KEY_PATH")" apps list
```

---

## 8. CI（GitHub Actions）

`.github/workflows/ios-testflight.yml` が `v*` タグ push または手動実行で TestFlight 配信します。
リポジトリの **Settings > Secrets and variables > Actions** に以下を登録してください:

- `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT_BASE64`
- `REVENUECAT_IOS_API_KEY`
- `DEVELOPER_TEAM_ID`

---

## 9. Shipaton メモ

- 提出要件は **RevenueCat SDK を用いた課金の実装**。本リポジトリでは
  `purchases_flutter` を統合し、`pro` Entitlement でゲートしています。
- RevenueCat ダッシュボードの Offering / Entitlement 名（`default` / `pro`）は
  コード（`RevenueCatConfig`）と一致させること。
- ペイウォールは `presentation/screens/paywall/paywall_screen.dart`。将来 RevenueCat の
  リモート Paywall（`purchases_ui_flutter`）へ差し替えることも可能です。

---

## 10. セキュリティ

- `.p8` 秘密鍵、`.env`、証明書類は `.gitignore` 済み。**コミットしないこと**。
- アプリに埋め込むのは RevenueCat の *Public* SDK Key のみ。*Secret* key はサーバー側専用。
