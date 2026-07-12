# 実機動作確認ログ

## 2026-07-05

- 端末: iPhone 16 Pro (iPhone17,1) / iOS 26.5 (23F77)
- アプリ: `com.himajin.himaJin` v1.0.0 (build 1)
- ビルド: `flutter run --release`(リリースビルド、Flutter VM Service非接続)
- 署名: Apple Development: kizamaya.toika@gmail.com / Team 9QG7B94N3U(有料Developer Program)
- 確認内容:
  - `xcrun devicectl device info apps` でインストール済みアプリとして確認
  - `xcrun devicectl device info processes` で実行中プロセスとして確認(PID 10405, 10469 / `/private/var/containers/Bundle/Application/.../Runner.app/Runner`)
  - Mac未接続でも動作継続(リリースビルドのためデバッガ接続不要)

## 2026-07-05 (再ビルド: アイコン/テーマ更新反映)

- 変更内容: ガラス質感アプリアイコン導入・テーマ色定義のAppColors一本化(PR #4, #6)を実機に反映
- ビルド: `flutter run --release -d 00008140-00096936017B001C`(Xcodeビルド 34.7s、インストール・起動 5.2s)
- 確認内容:
  - `xcrun devicectl device info apps` でインストール済みアプリとして確認(v1.0.0 build 1)
  - `xcrun devicectl device info processes` で実行中プロセスとして確認(PID 12789)
  - flutterツールのプロセスをkill後もアプリ自体は実行継続を確認

## 2026-07-05 (絵文字→自作アイコン(CustomPainter)置き換え反映)

- 変更内容: 行動タグ15種・実績75件で使用していたUnicode絵文字を全廃し、`AppIconType`(73種)+`AppIconPainter`(CustomPainterによる自作ベクター線画アイコン)に置き換え。ロック/トロフィー/レア度の★・👑バッジ等の付随emojiも同様に置き換え。
- 静的検証: `dart analyze lib` で0件(`flutter analyze`/`flutter test`はローカル環境の`flutter_tester`バイナリ欠如により実行不可 — 本変更とは無関係な環境要因)
- 目視検証: `flutter run -d chrome` でHome/実績一覧/実績詳細(ロック・アンロック双方)/プロフィール画面をスクリーンショット確認、全アイコンが意図通り描画されることを確認
- 実機反映: ビルドは2回とも成功(Xcodeビルド 16.5〜24.7s)。ワイヤレス接続時の`flutter run`自動起動は端末画面ロックにより失敗(`FBSOpenApplicationErrorDomain error 7 Locked`)したが、`xcrun devicectl device install app`で最新ビルドのインストール自体は成功を確認(databaseSequenceNumber 4980)。端末ロック解除後に手動起動すれば新アイコンが反映される想定。
