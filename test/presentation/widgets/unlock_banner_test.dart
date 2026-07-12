import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hima_jin/domain/conditions/achievement_condition.dart';
import 'package:hima_jin/domain/entities/achievement.dart';
import 'package:hima_jin/domain/enums/achievement_rarity.dart';
import 'package:hima_jin/presentation/widgets/icons/app_icon_type.dart';
import 'package:hima_jin/presentation/widgets/unlock_banner.dart';

import '../../helpers/pump_app.dart';

const _first = Achievement(
  id: 'a1',
  title: 'はじめの一歩',
  description: '最初の実績を解除した',
  icon: AppIconType.footprint,
  rarity: AchievementRarity.rare,
  condition: FirstLogCondition(),
);

const _second = Achievement(
  id: 'a2',
  title: '二番目の実績',
  description: 'ふたつめ',
  icon: AppIconType.star,
  rarity: AchievementRarity.common,
  condition: FirstLogCondition(),
);

const _third = Achievement(
  id: 'a3',
  title: '三番目の実績',
  description: 'みっつめ',
  icon: AppIconType.trophy,
  rarity: AchievementRarity.legendary,
  condition: FirstLogCondition(),
);

void main() {
  testWidgets(
      "shows the first achievement's title/description and no overflow badge for a single unlock",
      (tester) async {
    await tester.pumpWidget(wrapMinimal(UnlockBannerOverlay(
      achievements: const [_first],
      onDismiss: () {},
    )));
    await tester.pump();

    expect(find.text('実績解除！'), findsOneWidget);
    expect(find.text(_first.title), findsOneWidget);
    expect(find.text(_first.description), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);

    // UnlockBannerOverlay's 4s auto-dismiss is a bare Future.delayed with
    // no cancellation hook, so it can only be cleared by letting it fire
    // naturally; only then is it safe to unmount (disposing the
    // ConfettiController) without leaking a pending Timer.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(Container());
  });

  testWidgets(
      'shows a "+N" overflow badge when multiple achievements unlock at once',
      (tester) async {
    await tester.pumpWidget(wrapMinimal(UnlockBannerOverlay(
      achievements: const [_first, _second, _third],
      onDismiss: () {},
    )));
    await tester.pump();

    expect(find.text(_first.title), findsOneWidget);
    expect(find.text('+2'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(Container());
  });

  testWidgets('calls onDismiss automatically after the display delay',
      (tester) async {
    var dismissed = false;
    await tester.pumpWidget(wrapMinimal(UnlockBannerOverlay(
      achievements: const [_first],
      onDismiss: () => dismissed = true,
    )));
    await tester.pump();

    expect(dismissed, isFalse);

    await tester.pump(const Duration(seconds: 5));

    expect(dismissed, isTrue);

    await tester.pumpWidget(Container());
  });
}
