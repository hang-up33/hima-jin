import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    child: MaterialApp(home: child),
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
    child: MaterialApp.router(routerConfig: router),
  );
}

/// Minimal host for leaf widgets that don't read any Riverpod provider.
Widget wrapMinimal(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}
