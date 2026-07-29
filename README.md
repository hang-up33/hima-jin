# ヒマジン (hima_jin)

暇な時間の過ごし方をログして実績を解除していく、暇人のための実績解除ゲーム。
Flutter 製 iOS アプリ。

## 主な構成

- **状態管理**: Riverpod
- **ルーティング**: go_router
- **ローカル保存**: Hive
- **課金**: RevenueCat（`purchases_flutter`）— ヒマジンPro

## セットアップ

```sh
make setup     # flutter pub get
make run       # 起動（課金は無料モード）
make test      # テスト
```

## ヒマジンPro（課金）

RevenueCat による **ヒマジンPro** を導入しています。加入すると Pro 限定の実績パックが
解放されます。SDK キー未設定のビルドでは無料モードで通常どおり動作します。

```sh
make pro-run   # RevenueCat キーを注入して起動（.env 参照）
```

## App Store Connect API / 配信

App Store Connect API キー認証の fastlane・生 API ヘルパー・CI を同梱しています。

```sh
make asc-verify   # ASC API 疎通確認
make beta         # TestFlight へ配信
make asc-apps     # ASC API で App 一覧
```

課金・App Store Connect API・CI の詳細な手順は
**[docs/monetization.md](docs/monetization.md)** を参照してください。

## ドキュメント

- [docs/monetization.md](docs/monetization.md) — 課金 & App Store Connect API セットアップ
- [VERIFICATION.md](VERIFICATION.md) — 実機動作確認ログ
