import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/achievement.dart';
import '../../l10n/app_localizations.dart';
import 'icons/app_icon.dart';
import 'rarity_badge.dart';

class UnlockBannerOverlay extends StatefulWidget {
  const UnlockBannerOverlay({
    super.key,
    required this.achievements,
    required this.onDismiss,
  });

  final List<Achievement> achievements;
  final VoidCallback onDismiss;

  static OverlayEntry show(
    BuildContext context,
    List<Achievement> achievements,
  ) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => UnlockBannerOverlay(
        achievements: achievements,
        onDismiss: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
    return entry;
  }

  @override
  State<UnlockBannerOverlay> createState() => _UnlockBannerOverlayState();
}

class _UnlockBannerOverlayState extends State<UnlockBannerOverlay> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _confetti.play();
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(seconds: 4), widget.onDismiss);
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _BannerCard(achievements: widget.achievements)
              .animate()
              .slideY(begin: -1, end: 0, duration: 400.ms, curve: Curves.easeOut)
              .fadeIn(duration: 300.ms),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.05,
            colors: AppColors.confettiColors,
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final first = achievements.first;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.rarityColor(first.rarity),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.rarityGlow[first.rarity]!,
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                AppIcon(
                  first.icon,
                  size: 40,
                  color: AppColors.rarityColor(first.rarity),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.unlockBannerLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.rarityColor(first.rarity),
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        first.titleFor(locale),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        first.descriptionFor(locale),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    RarityBadge(
                      rarity: first.rarity,
                      color: AppColors.rarityColor(first.rarity),
                      iconSize: 12,
                      showLabel: false,
                    ),
                    if (achievements.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${achievements.length - 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
