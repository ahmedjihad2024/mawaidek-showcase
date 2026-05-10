import 'package:flutter/material.dart';

/// A global solution for keyboard dismissal that can be applied at the app level.
/// This widget wraps your entire app and provides keyboard dismissal functionality.
class GlobalKeyboardDismissal extends StatelessWidget {
  final Widget child;
  final bool enableKeyboardDismissal;

  const GlobalKeyboardDismissal({
    super.key,
    required this.child,
    this.enableKeyboardDismissal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableKeyboardDismissal) {
      return child;
    }

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping anywhere
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}

/// A custom MaterialApp that includes global keyboard dismissal
class KeyboardDismissalMaterialApp extends StatelessWidget {
  final String title;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale>? supportedLocales;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final Widget? home;
  final bool debugShowCheckedModeBanner;
  final bool enableKeyboardDismissal;

  const KeyboardDismissalMaterialApp({
    super.key,
    required this.title,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.home,
    this.debugShowCheckedModeBanner = true,
    this.enableKeyboardDismissal = true,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      color: color,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales ?? const [],
      routes: routes ?? const {},
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      navigatorObservers: navigatorObservers ?? const [],
      home: home,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      builder: (context, child) {
        if (!enableKeyboardDismissal) {
          return child!;
        }

        return GlobalKeyboardDismissal(
          child: child!,
        );
      },
    );
  }
}