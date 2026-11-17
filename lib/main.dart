import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'core/notifications/app_notifications.dart';
import 'core/utils/app_initializer.dart';
import 'lang/codegen_loader.g.dart';
import 'main_importants.dart';
import 'my_app.dart';

void main() async {
  runZonedGuarded(
    () async {
      await AppInitializer.init();

      // 🔹 Firebase Crashlytics: capture Flutter framework errors.
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // 🔹 Firebase Crashlytics: capture errors outside the Flutter framework.
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Must be registered before runApp so data-only messages are handled even
      // when the app is terminated.
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Foreground display, tap handling, iOS presentation and token syncing.
      await AppNotifications.initialize();
      runApp(
        EasyLocalization(
          startLocale: const Locale('ar', ""),
          supportedLocales: const [Locale('ar', ""), Locale('en', "")],
          path: 'assets/lang',
          saveLocale: true,
          fallbackLocale: const Locale('en', ""),
          useOnlyLangCode: true,
          assetLoader: const CodegenLoader(),
          child: const MyApp(),
        ),
      );

      // Handle a notification tap that launched the app from a terminated state.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNotifications.handleInitialMessage();
      });
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
