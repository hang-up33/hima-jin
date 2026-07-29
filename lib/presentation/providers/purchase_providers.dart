import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../data/repositories/purchase_repository.dart';

/// [PurchaseRepository] を提供する。
///
/// 既定は未初期化のインスタンス（`isAvailable == false` の無料モード）。
/// `main()` で [PurchaseRepository.init] 済みのインスタンスを `ProviderScope` の
/// override で注入する。テストでは既定のままでも安全に動作する。
final purchaseRepositoryProvider =
    Provider<PurchaseRepository>((ref) => PurchaseRepository());

/// RevenueCat の顧客情報を保持し、変化を購読する。
class CustomerInfoNotifier extends AsyncNotifier<CustomerInfo?> {
  @override
  Future<CustomerInfo?> build() async {
    final repo = ref.read(purchaseRepositoryProvider);

    void listener(CustomerInfo info) => state = AsyncData(info);
    repo.addCustomerInfoUpdateListener(listener);
    ref.onDispose(() => repo.removeCustomerInfoUpdateListener(listener));

    return repo.getCustomerInfo();
  }

  /// 顧客情報を再取得する（購入・復元後など）。
  Future<void> refresh() async {
    final repo = ref.read(purchaseRepositoryProvider);
    state = await AsyncValue.guard(repo.getCustomerInfo);
  }
}

final customerInfoProvider =
    AsyncNotifierProvider<CustomerInfoNotifier, CustomerInfo?>(
  CustomerInfoNotifier.new,
);

/// Pro Entitlement が有効かどうか。UI とゲート判定はこれを参照する。
final isProProvider = Provider<bool>((ref) {
  final info = ref.watch(customerInfoProvider).valueOrNull;
  return PurchaseRepository.isProActive(info);
});
