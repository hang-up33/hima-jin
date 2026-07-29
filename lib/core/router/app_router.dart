import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/achievements/achievements_screen.dart';
import '../../presentation/screens/detail/achievement_detail_screen.dart';
import '../../presentation/screens/paywall/paywall_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/widgets/himajin_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => HimaJinScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/achievements',
          builder: (context, state) => const AchievementsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/achievement/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AchievementDetailScreen(achievementId: id);
      },
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
  ],
);
