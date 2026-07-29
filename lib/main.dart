import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/activity_log_hive.dart';
import 'data/models/unlocked_achievement_hive.dart';
import 'presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityLogHiveAdapter());
  Hive.registerAdapter(UnlockedAchievementHiveAdapter());
  await Hive.openBox(LocaleController.settingsBoxName);
  runApp(const ProviderScope(child: HimaJinApp()));
}
