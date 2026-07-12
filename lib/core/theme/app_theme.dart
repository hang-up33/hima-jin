import 'package:flutter/material.dart';
import '../../domain/enums/achievement_rarity.dart';

class AppColors {
  static const background = Color(0xFFFFF9F5);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFFFF6B6B);
  static const primaryLight = Color(0xFFFFE8E8);
  static const primaryGradientEnd = Color(0xFFFF8E8E);
  static const secondary = Color(0xFF4ECDC4);
  static const accent = Color(0xFF9B59B6);
  static const danger = Color(0xFFFF5252);
  static const textPrimary = Color(0xFF2D2D2D);
  static const textSecondary = Color(0xFF757575);
  static const onPrimary = Colors.white;
  static const cardShadow = Color(0x1A000000);

  static Color rarityColor(AchievementRarity rarity) =>
      Color(rarity.colorValue);

  static const Map<AchievementRarity, Color> rarityGlow = {
    AchievementRarity.common: Color(0x40AAAAAA),
    AchievementRarity.uncommon: Color(0x404CAF50),
    AchievementRarity.rare: Color(0x402196F3),
    AchievementRarity.legendary: Color(0x80FFD700),
  };

  static const List<Color> confettiColors = [
    primary,
    secondary,
    Color(0xFFFFD700),
    accent,
  ];
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shadowColor: AppColors.cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
}
