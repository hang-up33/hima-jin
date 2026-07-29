import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Persisted app-language selection.
///
/// State is a [Locale] for an explicit choice, or `null` to follow the device
/// locale. When no choice has ever been saved the app defaults to English
/// (see [_load]). The selection is stored in the `settings` Hive box, which
/// [main] opens at startup; when that box is unavailable (e.g. in widget
/// tests) the controller degrades to an in-memory default so it never throws.
final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) {
  return LocaleController();
});

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(_load());

  static const settingsBoxName = 'settings';
  static const _localeKey = 'localeCode';

  /// Sentinel stored when the user explicitly picks "follow the device".
  static const _systemValue = 'system';

  static Locale? _load() {
    if (!Hive.isBoxOpen(settingsBoxName)) return const Locale('en');
    final box = Hive.box(settingsBoxName);
    final code = box.get(_localeKey, defaultValue: 'en') as String?;
    if (code == null || code == _systemValue) return null;
    return Locale(code);
  }

  /// [locale] == null means "follow the device locale".
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (!Hive.isBoxOpen(settingsBoxName)) return;
    final box = Hive.box(settingsBoxName);
    await box.put(_localeKey, locale?.languageCode ?? _systemValue);
  }
}
