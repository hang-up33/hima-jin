import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hima_jin/l10n/app_localizations.dart';

/// Localization wiring shared by every test host below, mirroring what the
/// real [MaterialApp] in `app.dart` sets up. Without these delegates
/// `AppLocalizations.of(context)` would be null and localized widgets would
/// throw. Tests run under the default `en` locale.
const _localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Wraps [child] in a bare [ProviderScope] with the given [overrides] —
/// for widgets that are already a full `MaterialApp`/`MaterialApp.router`
/// (e.g. the root `HimaJinApp`), which must not be wrapped in another one.
Widget wrapWithProviderScope(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(overrides: overrides, child: child);
}

/// Wraps [child] in a [ProviderScope] with the given [overrides] and a
/// minimal [MaterialApp] — the common host for screen/widget tests that
/// read Riverpod providers but don't need real navigation.
Widget wrapWithProviders(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Same as [wrapWithProviders], but hosts the app behind [router] instead
/// of a fixed `home:` — for tests that exercise real navigation.
Widget wrapWithProvidersAndRouter(
  GoRouter router, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

/// Minimal host for leaf widgets that don't read any Riverpod provider.
Widget wrapMinimal(Widget child) {
  return MaterialApp(
    localizationsDelegates: _localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
