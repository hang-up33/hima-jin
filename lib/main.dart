import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/activity_log_hive.dart';
import 'data/models/unlocked_achievement_hive.dart';
import 'data/repositories/purchase_repository.dart';
import 'presentation/providers/purchase_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityLogHiveAdapter());
  Hive.registerAdapter(UnlockedAchievementHiveAdapter());

  // RevenueCat（課金）を初期化。キー未設定なら無料モードで続行する。
  final purchaseRepository = PurchaseRepository();
  await purchaseRepository.init();

  runApp(
    ProviderScope(
      overrides: [
        purchaseRepositoryProvider.overrideWithValue(purchaseRepository),
      ],
      child: const HimaJinApp(),
    ),
  );
}
