import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/config/revenuecat_config.dart';

/// RevenueCat SDK をラップする課金リポジトリ。
///
/// SDK キーが未設定の場合は [isAvailable] が `false` になり、各メソッドは
/// 例外を投げずに無害な既定値（Pro 未加入相当）を返す。これによりテストや
/// CI、キー無しのレビュー環境でもアプリが問題なく起動する。
class PurchaseRepository {
  bool _available = false;

  /// RevenueCat が初期化済みで課金機能を利用できるか。
  bool get isAvailable => _available;

  CustomerInfo get _defaultCustomerInfo {
    final now = DateTime.now().toIso8601String();
    return CustomerInfo(
      const EntitlementInfos({}, {}),
      const {},
      const [],
      const [],
      const [],
      now,
      '',
      const {},
      now,
    );
  }

  /// アプリ起動時に一度だけ呼び出して SDK を初期化する。
  Future<void> init() async {
    if (!RevenueCatConfig.isConfigured) return;

    final apiKey = Platform.isAndroid
        ? RevenueCatConfig.androidApiKey
        : RevenueCatConfig.iosApiKey;
    if (apiKey.isEmpty) return;

    await Purchases.setLogLevel(LogLevel.info);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    _available = true;
  }

  /// 現在の顧客情報を取得する。未初期化なら `null`。
  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_available) return null;
    return Purchases.getCustomerInfo();
  }

  /// 顧客情報の変化を購読する。
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    if (!_available) return;
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    if (!_available) return;
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  /// 表示すべき Offering を取得する。
  ///
  /// [RevenueCatConfig.defaultOfferingId] を優先し、無ければ `current` を返す。
  Future<Offering?> getCurrentOffering() async {
    if (!_available) return null;
    final offerings = await Purchases.getOfferings();
    return offerings.getOffering(RevenueCatConfig.defaultOfferingId) ??
        offerings.current;
  }

  /// パッケージを購入し、更新後の顧客情報を返す。
  ///
  /// ユーザーがキャンセルした場合など、失敗時は例外を送出する。呼び出し側は
  /// [PurchasesErrorHelper.getErrorCode] でハンドリングすること。
  Future<CustomerInfo> purchase(Package package) {
    if (!_available) return Future.value(_defaultCustomerInfo);
    return Purchases.purchasePackage(package);
  }

  /// 過去の購入を復元し、更新後の顧客情報を返す。
  Future<CustomerInfo> restore() {
    if (!_available) return Future.value(_defaultCustomerInfo);
    return Purchases.restorePurchases();
  }

  /// 顧客情報から Pro Entitlement が有効かどうかを判定する。
  static bool isProActive(CustomerInfo? info) {
    final entitlement =
        info?.entitlements.active[RevenueCatConfig.entitlementPro];
    return entitlement?.isActive ?? false;
  }
}
