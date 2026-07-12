import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/enums/achievement_rarity.dart';
import 'package:hima_jin/presentation/widgets/icons/app_icon.dart';
import 'package:hima_jin/presentation/widgets/icons/app_icon_type.dart';
import 'package:hima_jin/presentation/widgets/rarity_badge.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('common rarity renders 1 star icon and its label',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(const RarityBadge(
      rarity: AchievementRarity.common,
      color: Colors.grey,
    )));

    final icons = tester.widgetList<AppIcon>(find.byType(AppIcon));
    expect(icons, hasLength(1));
    expect(icons.every((i) => i.type == AppIconType.star), isTrue);
    expect(find.text('Common'), findsOneWidget);
  });

  testWidgets('rare rarity renders 3 star icons', (tester) async {
    await tester.pumpWidget(wrapMinimal(const RarityBadge(
      rarity: AchievementRarity.rare,
      color: Colors.blue,
    )));

    final icons = tester.widgetList<AppIcon>(find.byType(AppIcon));
    expect(icons, hasLength(3));
    expect(icons.every((i) => i.type == AppIconType.star), isTrue);
  });

  testWidgets('legendary rarity renders a single crown icon, no stars',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(const RarityBadge(
      rarity: AchievementRarity.legendary,
      color: Colors.amber,
    )));

    final icons = tester.widgetList<AppIcon>(find.byType(AppIcon));
    expect(icons, hasLength(1));
    expect(icons.single.type, AppIconType.crown);
  });

  testWidgets('showLabel false hides the label text', (tester) async {
    await tester.pumpWidget(wrapMinimal(const RarityBadge(
      rarity: AchievementRarity.common,
      color: Colors.grey,
      showLabel: false,
    )));

    expect(find.text('Common'), findsNothing);
  });
}
