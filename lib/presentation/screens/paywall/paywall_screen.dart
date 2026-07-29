import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants/achievements_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../providers/achievement_providers.dart';
import '../../providers/purchase_providers.dart';
import '../../widgets/icons/app_icon.dart';
import '../../widgets/icons/app_icon_type.dart';

/// ヒマジンPro のペイウォール画面。
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Offering? _offering;
  bool _loading = true;
  bool _purchasing = false;
  String? _error;
  Package? _selected;

  @override
  void initState() {
    super.initState();
    _loadOffering();
  }

  Future<void> _loadOffering() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(purchaseRepositoryProvider);
      final offering = await repo.getCurrentOffering();
      if (!mounted) return;
      setState(() {
        _offering = offering;
        _selected = offering?.availablePackages.isNotEmpty ?? false
            ? offering!.availablePackages.first
            : null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '商品情報の取得に失敗しました';
        _loading = false;
      });
    }
  }

  Future<void> _purchase(Package package) async {
    setState(() {
      _purchasing = true;
      _error = null;
    });
    try {
      final repo = ref.read(purchaseRepositoryProvider);
      final info = await repo.purchase(package);
      await _onEntitlementUpdated(PurchaseRepository.isProActive(info),
          success: 'ヒマジンProへようこそ！🎉');
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        // ユーザーによるキャンセルはエラー表示しない。
      } else {
        _showError('購入に失敗しました');
      }
    } catch (_) {
      _showError('購入に失敗しました');
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _purchasing = true;
      _error = null;
    });
    try {
      final repo = ref.read(purchaseRepositoryProvider);
      final info = await repo.restore();
      final isPro = PurchaseRepository.isProActive(info);
      await _onEntitlementUpdated(
        isPro,
        success: 'Proを復元しました',
        failure: '復元できる購入がありませんでした',
      );
    } catch (_) {
      _showError('復元に失敗しました');
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _onEntitlementUpdated(
    bool isPro, {
    required String success,
    String? failure,
  }) async {
    // 顧客情報を反映し、Pro 実績のチェックを走らせる。
    await ref.read(customerInfoProvider.notifier).refresh();
    if (isPro) {
      await ref.read(unlockedAchievementsProvider.notifier).checkAndUnlock();
    }
    if (!mounted) return;
    final message = isPro ? success : (failure ?? success);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    if (isPro) Navigator.of(context).maybePop();
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _error = message);
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);
    final repoAvailable = ref.read(purchaseRepositoryProvider).isAvailable;

    return Scaffold(
      appBar: AppBar(title: const Text('ヒマジンPro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProHeader(),
              const SizedBox(height: 24),
              const _BenefitsCard(),
              const SizedBox(height: 24),
              if (isPro)
                _StatusCard(
                  icon: AppIconType.checkMark,
                  text: 'すでにヒマジンProに加入済みです。ありがとうございます！',
                )
              else if (!repoAvailable)
                _StatusCard(
                  icon: AppIconType.store,
                  text: '現在このビルドでは課金機能が無効です。\n'
                      'App Store 経由のビルドでご利用いただけます。',
                )
              else if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_offering == null ||
                  _offering!.availablePackages.isEmpty)
                _StatusCard(
                  icon: AppIconType.store,
                  text: '現在購入可能なプランがありません。',
                )
              else
                ..._buildPurchaseSection(),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              const _LegalFooter(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPurchaseSection() {
    final packages = _offering!.availablePackages;
    return [
      ...packages.map((package) {
        final selected = package.identifier == _selected?.identifier;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PackageTile(
            package: package,
            selected: selected,
            onTap: _purchasing
                ? null
                : () => setState(() => _selected = package),
          ),
        );
      }),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: (_purchasing || _selected == null)
            ? null
            : () => _purchase(_selected!),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _purchasing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Text(
                'Proにアップグレード',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _purchasing ? null : _restore,
        child: const Text('購入を復元'),
      ),
    ];
  }
}

class _ProHeader extends StatelessWidget {
  const _ProHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const AppIcon(AppIconType.crown, size: 48, color: AppColors.onPrimary),
          const SizedBox(height: 12),
          const Text(
            'ヒマジンPro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '限定Pro実績 $kProAchievementCount 種を解放しよう',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  @override
  Widget build(BuildContext context) {
    final proAchievements =
        kAllAchievements.where((a) => a.isPro).take(5).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proでできること',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...proAchievements.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  AppIcon(a.icon, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      a.title.replaceFirst('【Pro】', ''),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'ほか、開発への応援になります 💪',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.selected,
    required this.onTap,
  });

  final Package package;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final product = package.storeProduct;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardShadow,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title.replaceAll(RegExp(r'\s*\(.*\)$'), ''),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              product.priceString,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.icon, required this.text});

  final AppIconType icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          AppIcon(icon, size: 24, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '購入は App ID に紐づく Apple アカウントに請求されます。'
      'サブスクリプションは期間終了の24時間以上前に解約しない限り自動更新されます。'
      '購入後は App Store の設定から管理・解約できます。',
      style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}
