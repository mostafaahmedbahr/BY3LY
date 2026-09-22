import 'package:firebase_messaging/firebase_messaging.dart';
import '../app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/extensions/log.dart';
import 'dart:io';


Future<void> getDeviceToken() async {
  try {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🔹 طلب الإذن
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      logWarning("❌ Notification permission denied");
      return;
    }

    String? fcmToken;

    // =========================
    // 📱 ANDROID
    // =========================
    if (Platform.isAndroid) {
      fcmToken = await messaging.getToken();

      if (fcmToken != null) {
        logSuccess("🤖 Android FCM Token: $fcmToken");

        await CacheHelper.saveData(
          key: "fcmToken",
          value: fcmToken,
        );
      }
    }

    // =========================
    // 🍎 iOS
    // =========================
    else if (Platform.isIOS) {
      // 🔹 ندي وقت لـ APNS Token عشان يجهز
      await Future.delayed(const Duration(seconds: 1));

      String? apnsToken = await messaging.getAPNSToken();

      if (apnsToken == null) {
        logWarning("⏳ APNS Token not ready, retrying...");

        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await messaging.getAPNSToken();
      }

      if (apnsToken != null) {
        logSuccess("🍏 APNS Token: $apnsToken");
      }

      // 🔹 بعد كده نجيب FCM Token
      fcmToken = await messaging.getToken();

      if (fcmToken != null) {
        logSuccess("🔥 iOS FCM Token: $fcmToken");

        await CacheHelper.saveData(
          key: "fcmToken",
          value: fcmToken,
        );
      } else {
        logError("❌ Failed to get FCM token on iOS");
      }
    }

    // =========================
    // 🔄 Token Refresh (كل الأجهزة)
    // =========================
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      logSuccess("🔄 Token Refreshed: $newToken");

      await CacheHelper.saveData(
        key: "fcmToken",
        value: newToken,
      );
    });

  } catch (e) {
    logError("❌ Error getting device token: $e");
  }
}