import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/conditions/achievement_condition.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/enums/achievement_rarity.dart';
import 'package:hima_jin/presentation/screens/achievements/widgets/achievement_badge.dart';
import 'package:hima_jin/presentation/widgets/icons/app_icon.dart';
import 'package:hima_jin/presentation/widgets/icons/app_icon_type.dart';

import '../../helpers/pump_app.dart';

const _visible = Achievement(
  id: 'test_visible',
  title: 'テスト実績',
  description: 'desc',
  icon: AppIconType.footprint,
  rarity: AchievementRarity.common,
  condition: FirstLogCondition(),
);

const _hidden = Achievement(
  id: 'test_hidden',
  title: '秘密実績',
  description: 'desc',
  icon: AppIconType.footprint,
  rarity: AchievementRarity.rare,
  condition: FirstLogCondition(),
  isHidden: true,
);

void main() {
  testWidgets('locked, non-hidden achievement shows its icon and title',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(AchievementBadge(
      achievement: _visible,
      unlockedAt: null,
      onTap: () {},
    )));
    await tester.pumpAndSettle();

    expect(find.text('テスト実績'), findsOneWidget);
    final icon = tester.widget<AppIcon>(find.byType(AppIcon));
    expect(icon.type, AppIconType.footprint);
  });

  testWidgets('locked, hidden achievement shows a lock icon and "???"',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(AchievementBadge(
      achievement: _hidden,
      unlockedAt: null,
      onTap: () {},
    )));
    await tester.pumpAndSettle();

    expect(find.text('???'), findsOneWidget);
    expect(find.text('秘密実績'), findsNothing);
    final icon = tester.widget<AppIcon>(find.byType(AppIcon));
    expect(icon.type, AppIconType.lock);
  });

  testWidgets('unlocked achievement shows its title and unlock date',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(AchievementBadge(
      achievement: _visible,
      unlockedAt: DateTime(2025, 6, 3),
      onTap: () {},
    )));
    await tester.pumpAndSettle();

    expect(find.text('テスト実績'), findsOneWidget);
    expect(find.text('6/3'), findsOneWidget);
  });

  testWidgets('tapping the badge invokes onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrapMinimal(AchievementBadge(
      achievement: _visible,
      unlockedAt: null,
      onTap: () => tapped = true,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AchievementBadge));

    expect(tapped, isTrue);
  });
}
