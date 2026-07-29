# ヒマジン — よく使うコマンド集
.PHONY: help setup analyze test run pro-run asc-verify asc-apps asc-token beta release

help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

setup: ## 依存関係を取得
	flutter pub get
	@command -v bundle >/dev/null 2>&1 && bundle install || echo "(bundler 未インストール: fastlane を使う場合は gem install bundler)"

analyze: ## 静的解析
	flutter analyze

test: ## テスト実行
	flutter test

run: ## 通常起動（課金は無料モード）
	flutter run

pro-run: ## RevenueCat キーを注入して起動（.env の値を使用）
	@set -a; [ -f .env ] && . ./.env; set +a; \
	flutter run \
	  --dart-define=REVENUECAT_IOS_API_KEY=$${REVENUECAT_IOS_API_KEY} \
	  --dart-define=REVENUECAT_ANDROID_API_KEY=$${REVENUECAT_ANDROID_API_KEY}

asc-verify: ## App Store Connect API キーの疎通確認（fastlane）
	bundle exec fastlane ios verify_api

asc-apps: ## ASC API で App 一覧を取得
	./scripts/asc_api.sh apps

asc-token: ## ASC API 用の JWT を生成
	@python3 scripts/asc_token.py

beta: ## TestFlight へ配信
	bundle exec fastlane ios beta

release: ## App Store 審査提出用にアップロード
	bundle exec fastlane ios release
