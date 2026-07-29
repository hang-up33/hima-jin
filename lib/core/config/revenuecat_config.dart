/// RevenueCat（課金基盤）の設定値。
///
/// Public SDK Key はビルド時に `--dart-define` で注入する。ソースには埋め込まない。
///
/// ```sh
/// flutter run \
///   --dart-define=REVENUECAT_IOS_API_KEY=appl_xxxxxxxxxxxxxxxxxxxx \
///   --dart-define=REVENUECAT_ANDROID_API_KEY=goog_xxxxxxxxxxxxxxxxxxxx
/// ```
///
/// キーが未設定のビルド（テスト・CI・レビュー環境など）では RevenueCat の初期化を
/// スキップし、アプリは「無料（Pro未加入）」状態で通常どおり動作する。
class RevenueCatConfig {
  const RevenueCatConfig._();

  /// iOS 用の RevenueCat Public SDK Key（`appl_` から始まる）。
  static const String iosApiKey =
      String.fromEnvironment('REVENUECAT_IOS_API_KEY');

  /// Android 用の RevenueCat Public SDK Key（`goog_` から始まる）。
  static const String androidApiKey =
      String.fromEnvironment('REVENUECAT_ANDROID_API_KEY');

  /// Pro を表す Entitlement 識別子。RevenueCat ダッシュボードの
  /// Entitlements で作成した ID と一致させる。
  static const String entitlementPro = 'pro';

  /// 既定 Offering の識別子。未指定時は `current` にフォールバックする。
  static const String defaultOfferingId = 'default';

  /// いずれかのプラットフォームキーが設定されているか。
  static bool get isConfigured =>
      iosApiKey.isNotEmpty || androidApiKey.isNotEmpty;
}
