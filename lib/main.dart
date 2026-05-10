import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mawadk/app/constants.dart';
import 'package:mawadk/app/supported_locales.dart';
import 'package:mawadk/firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app/app.dart';
import 'app/dependency_injection.dart';
import 'app/services/firebase_messeging_services.dart';

/// Read at compile time via `--dart-define=SENTRY_DSN=...`. Empty string
/// disables Sentry — that's the default for local dev. Production and
/// TestFlight builds pass the real DSN at build time.
const _sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

//* For development build
//? flutter run --flavor dev
//? flutter run --release --flavor dev
//? flutter build apk --release --flavor dev

//* For production APK
//? flutter build apk --release --flavor prod
//* For production App Bundle
//? flutter build appbundle --release --flavor prod

/// Wraps `runApp` with Sentry initialisation. If [_sentryDsn] is empty
/// (local dev), this just calls `runner()` and skips the SDK entirely.
Future<void> _bootstrap(FutureOr<Widget> Function() builder) async {
  if (_sentryDsn.isEmpty) {
    runApp(await builder());
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      // Conservative on free tier — bumps back up to 1.0 only when
      // we're actively investigating something specific.
      options.tracesSampleRate = 0.2;
      options.profilesSampleRate = 0.0;
      options.environment = kDebugMode ? 'debug' : 'production';
    },
    appRunner: () async => runApp(await builder()),
  );
}

void main() {
  runZonedGuarded(() async {
    // Before anything else
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessegingServices.instance.initialize();

    // init app modules
    await initAppModules();

    // init localization for ar and en
    await EasyLocalization.ensureInitialized();

    // set system ui overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    // set system ui mode to edge to edge
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await _bootstrap(() => EasyLocalization(
          supportedLocales: SupportedLocales.allLocales,
          path: Constants.translationsPath,
          fallbackLocale: SupportedLocales.EN.locale,
          startLocale: SupportedLocales.EN.locale,
          child: Phoenix(
            key: Key("phoenix"),
            child: MyApp(),
          ),
        ));
  }, (_, error) {
    if (kDebugMode) {
      print(error.toString());
    }
  });
}




// @api.dart @dependency_injection.dart @request.dart @responses.dart @base.dart @repository.dart @repository_impl.dart @type_review_usecase.dart 
// understand type reivew usecase and add the following



