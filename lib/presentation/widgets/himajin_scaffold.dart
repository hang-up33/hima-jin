import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class HimaJinScaffold extends StatelessWidget {
  const HimaJinScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    (asset: 'assets/images/nav_home.png', path: '/home'),
    (asset: 'assets/images/nav_achievements.png', path: '/achievements'),
    (asset: 'assets/images/nav_profile.png', path: '/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  // ガラス質感のアイコンはラスター画像のため色替えが効かない。
  // 選択状態は不透明度で表現する（選択=くっきり / 非選択=薄く）。
  Widget _icon(String asset, {required bool active}) {
    final image = Image.asset(asset, width: 28, height: 28);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: active ? image : Opacity(opacity: 0.4, child: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    final l10n = AppLocalizations.of(context);
    final labels = [l10n.navHome, l10n.navAchievements, l10n.navProfile];
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(_tabs[i].path),
        items: [
          for (int i = 0; i < _tabs.length; i++)
            BottomNavigationBarItem(
              icon: _icon(_tabs[i].asset, active: false),
              activeIcon: _icon(_tabs[i].asset, active: true),
              label: labels[i],
            ),
        ],
      ),
    );
  }
}
