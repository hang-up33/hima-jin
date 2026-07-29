import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Hand-written localization bundle for the app's UI chrome.
///
/// This intentionally avoids code generation (`flutter gen-l10n`) so the whole
/// string table is reviewable in one place and needs no build step. Register
/// [delegate] and [supportedLocales] on the root `MaterialApp`, then read the
/// active bundle with `AppLocalizations.of(context)`.
///
/// Content that lives in domain data — achievement titles/descriptions and
/// activity-tag labels — is localized on those models themselves
/// (`Achievement.titleFor`, `ActivityTag.labelFor`), because they are `const`
/// and have no `BuildContext`.
abstract class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ja')];

  // --- App / navigation ---
  String get appTitle;
  String get navHome;
  String get navAchievements;
  String get navProfile;

  // --- Home ---
  String get homeHeading;
  String get homeSubtitle;
  String get homeTodaySection;

  // --- Log entry sheet ---
  String get logButton;
  String get updateButton;
  String get durationPrompt;
  String get noteHint;

  // --- Achievements ---
  String get tabAll;
  String get emptyAchievements;

  // --- Achievement detail ---
  String get detailTitle;
  String get hiddenLockedDescription;
  String get unlockedAtLabel;
  String get progressLabel;

  // --- Unlock banner ---
  String get unlockBannerLabel;

  // --- Profile ---
  String get profileTitle;
  String get statStreak;
  String get statTotalLogs;
  String get statTotalTime;
  String get topTagsTitle;
  String get aboutLicenses;

  // --- Language setting ---
  String get languageSettingTitle;
  String get languageSystem;
  String get languageEnglish;
  String get languageJapanese;

  // --- Parameterized ---
  String achievementsHeader(int count, int total);
  String levelLabel(int level);
  String profileTier(int count);
  String streakValue(int days);
  String logsValue(int count);
  String hoursValue(int hours);

  /// Label for a duration quick-pick chip. [plus] renders the "or more"
  /// trailing marker used by the longest option.
  String durationChip(int minutes, {bool plus = false});

  /// Human-readable duration shown next to a log entry (minutes > 0).
  String durationText(int minutes);

  /// Share sheet text for an unlocked achievement.
  String shareText(String title);

  /// Full "unlocked at" timestamp for the detail screen.
  String formatUnlockedAt(DateTime dt);
}

class AppLocalizationsEn extends AppLocalizations {
  const AppLocalizationsEn();

  @override
  String get appTitle => 'Himajin';
  @override
  String get navHome => 'Home';
  @override
  String get navAchievements => 'Achievements';
  @override
  String get navProfile => 'Profile';

  @override
  String get homeHeading => 'What did you do today?';
  @override
  String get homeSubtitle => 'Tap to log it';
  @override
  String get homeTodaySection => "Today's logs";

  @override
  String get logButton => 'Log it';
  @override
  String get updateButton => 'Update';
  @override
  String get durationPrompt => 'How long?';
  @override
  String get noteHint => 'Note (optional)';

  @override
  String get tabAll => 'All';
  @override
  String get emptyAchievements => 'No achievements yet';

  @override
  String get detailTitle => 'Achievement Details';
  @override
  String get hiddenLockedDescription => 'A mystery until you unlock it...';
  @override
  String get unlockedAtLabel => 'Unlocked';
  @override
  String get progressLabel => 'Progress';

  @override
  String get unlockBannerLabel => 'Achievement Unlocked!';

  @override
  String get profileTitle => 'Profile';
  @override
  String get statStreak => 'Streak';
  @override
  String get statTotalLogs => 'Total Logs';
  @override
  String get statTotalTime => 'Total Time';
  @override
  String get topTagsTitle => 'Top 5 Activities';
  @override
  String get aboutLicenses => 'Open-Source Licenses';

  @override
  String get languageSettingTitle => 'Language';
  @override
  String get languageSystem => 'System';
  @override
  String get languageEnglish => 'English';
  @override
  String get languageJapanese => '日本語';

  @override
  String achievementsHeader(int count, int total) =>
      'Achievements $count / $total';
  @override
  String levelLabel(int level) => 'Lv.$level';
  @override
  String profileTier(int count) {
    if (count >= 50) return 'Idle God';
    if (count >= 30) return 'Idle King';
    if (count >= 15) return 'Intermediate Idler';
    if (count >= 5) return 'Apprentice Idler';
    return 'Rookie Idler';
  }

  @override
  String streakValue(int days) => '${days}d';
  @override
  String logsValue(int count) => '$count';
  @override
  String hoursValue(int hours) => '${hours}h';

  @override
  String durationChip(int minutes, {bool plus = false}) {
    final base = minutes == 0
        ? 'Not set'
        : minutes < 60
            ? '${minutes}m'
            : '${minutes ~/ 60}h';
    return plus ? '$base+' : base;
  }

  @override
  String durationText(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  @override
  String shareText(String title) => 'I unlocked "$title"! 🎉\n#Himajin';

  @override
  String formatUnlockedAt(DateTime dt) =>
      DateFormat('MMM d, yyyy HH:mm').format(dt);
}

class AppLocalizationsJa extends AppLocalizations {
  const AppLocalizationsJa();

  @override
  String get appTitle => 'ヒマジン';
  @override
  String get navHome => 'ホーム';
  @override
  String get navAchievements => '実績';
  @override
  String get navProfile => 'プロフィール';

  @override
  String get homeHeading => '今日何した？';
  @override
  String get homeSubtitle => 'タップして記録しよう';
  @override
  String get homeTodaySection => '今日の記録';

  @override
  String get logButton => '記録する';
  @override
  String get updateButton => '更新する';
  @override
  String get durationPrompt => 'どのくらい？';
  @override
  String get noteHint => 'メモ（任意）';

  @override
  String get tabAll => 'すべて';
  @override
  String get emptyAchievements => 'まだ実績がありません';

  @override
  String get detailTitle => '実績詳細';
  @override
  String get hiddenLockedDescription => '解除するまで謎のまま...';
  @override
  String get unlockedAtLabel => '解除日時';
  @override
  String get progressLabel => '進捗';

  @override
  String get unlockBannerLabel => '実績解除！';

  @override
  String get profileTitle => 'プロフィール';
  @override
  String get statStreak => '連続ログイン';
  @override
  String get statTotalLogs => '総記録件数';
  @override
  String get statTotalTime => '総時間';
  @override
  String get topTagsTitle => 'よくやること TOP5';
  @override
  String get aboutLicenses => 'オープンソースライセンス';

  @override
  String get languageSettingTitle => '言語';
  @override
  String get languageSystem => '端末に合わせる';
  @override
  String get languageEnglish => 'English';
  @override
  String get languageJapanese => '日本語';

  @override
  String achievementsHeader(int count, int total) => '実績 $count / $total';
  @override
  String levelLabel(int level) => 'Lv.$level';
  @override
  String profileTier(int count) {
    if (count >= 50) return '暇人の神';
    if (count >= 30) return '暇人の王';
    if (count >= 15) return '中級暇人';
    if (count >= 5) return '見習い暇人';
    return '新米暇人';
  }

  @override
  String streakValue(int days) => '$days日';
  @override
  String logsValue(int count) => '$count件';
  @override
  String hoursValue(int hours) => '$hours時間';

  @override
  String durationChip(int minutes, {bool plus = false}) {
    final base = minutes == 0
        ? '未設定'
        : minutes < 60
            ? '$minutes分'
            : '${minutes ~/ 60}時間';
    return plus ? '$base+' : base;
  }

  @override
  String durationText(int minutes) {
    if (minutes < 60) return '$minutes分';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h時間' : '$h時間$m分';
  }

  @override
  String shareText(String title) => '「$title」の実績を解除しました！ 🎉\n#ヒマジン #暇人実績';

  @override
  String formatUnlockedAt(DateTime dt) =>
      DateFormat('yyyy年M月d日 HH:mm').format(dt);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(
        locale.languageCode == 'ja'
            ? const AppLocalizationsJa()
            : const AppLocalizationsEn(),
      );

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
