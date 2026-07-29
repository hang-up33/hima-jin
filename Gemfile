source "https://rubygems.org"

# App Store Connect API を使ったビルド配信・メタデータ管理に fastlane を利用する。
gem "fastlane"

plugins_path = File.join(File.dirname(__FILE__), "fastlane", "Pluginfile")
eval_gemfile(plugins_path) if File.exist?(plugins_path)
