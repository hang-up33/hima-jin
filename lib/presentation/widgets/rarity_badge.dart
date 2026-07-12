import 'package:flutter/widgets.dart';

import '../../domain/enums/achievement_rarity.dart';
import 'icons/app_icon.dart';
import 'icons/app_icon_type.dart';

/// Renders a rarity as a row of star icons (or a crown for legendary)
/// followed by its label — the icon-based replacement for the old
/// `'★★★ Rare'` / `'👑 Legendary'` text strings.
class RarityBadge extends StatelessWidget {
  const RarityBadge({
    super.key,
    required this.rarity,
    required this.color,
    this.iconSize = 14,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w600,
    this.showLabel = true,
  });

  final AchievementRarity rarity;
  final Color color;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rarity.isLegendary)
          AppIcon(AppIconType.crown, size: iconSize, color: color)
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              rarity.starCount,
              (_) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: AppIcon(AppIconType.star, size: iconSize, color: color),
              ),
            ),
          ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            rarity.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
