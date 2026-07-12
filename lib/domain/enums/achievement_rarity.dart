enum AchievementRarity {
  common('Common', 1, 0xFFAAAAAA),
  uncommon('Uncommon', 2, 0xFF4CAF50),
  rare('Rare', 3, 0xFF2196F3),
  legendary('Legendary', 0, 0xFFFFD700);

  const AchievementRarity(this.label, this.starCount, this.colorValue);

  final String label;

  /// Number of star icons to show for this rarity; 0 means legendary,
  /// which shows a crown icon instead of stars.
  final int starCount;
  final int colorValue;

  bool get isLegendary => starCount == 0;
}
