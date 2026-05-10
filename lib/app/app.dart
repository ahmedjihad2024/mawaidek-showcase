import 'package:easy_localization/easy_localization.dart';
import 'package:mawadk/presentation/common/ui_components/global_keyboard_dismissal.dart';
import 'package:flutter/material.dart';

import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/theme_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GlobalKey<ScaffoldMessengerState> SCAFFOLD_MESSENGER_KEY =
    GlobalKey<ScaffoldMessengerState>();
GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    SCAFFOLD_MESSENGER_KEY = GlobalKey<ScaffoldMessengerState>();
    NAVIGATOR_KEY = GlobalKey<NavigatorState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, details) {
          return MaterialApp(
            scaffoldMessengerKey: SCAFFOLD_MESSENGER_KEY,
            navigatorKey: NAVIGATOR_KEY,
            debugShowCheckedModeBanner:
                false, //  FlavorConfig.instance.showBanner,
            initialRoute: RoutesManager.home.route,
            theme: ThemeManager.lightTheme(context),
            // darkTheme: ThemeManager.darkTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: RoutesGeneratorManager.getRoute,
            builder: (context, child) {
              return GlobalKeyboardDismissal(
                child: child!,
              );
            },
          );
        });
  }

  set setTheme(ThemeMode themeMode) {
    Phoenix.rebirth(context);
  }

}
