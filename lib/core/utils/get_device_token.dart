import 'package:firebase_messaging/firebase_messaging.dart';
import '../app_services/local_services/cache_helper.dart';
import '../notifications/device_token_sync.dart';
import '../utils/app_consts/storage_keys.dart';
import 'package:by3ly/core/extensions/log.dart';
import 'dart:io';

/// Returns the cached FCM token, fetching it on demand if missing.
Future<String> getFcmToken() async {
  String? token = CacheHelper.getData(key: StorageKeys.fcmToken)?.toString();
  if (token != null && token.isNotEmpty) return token;
  await getDeviceToken();
  token = CacheHelper.getData(key: StorageKeys.fcmToken)?.toString();
  return token ?? '';
}

Future<void> getDeviceToken() async {
  try {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
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

    if (Platform.isAndroid) {
      for (int i = 0; i < 3 && (fcmToken == null || fcmToken.isEmpty); i++) {
        try {
          fcmToken = await messaging.getToken();
        } catch (e) {
          logWarning("⏳ getToken attempt ${i + 1} failed: $e");
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        logSuccess("Android FCM Token: $fcmToken");
        await CacheHelper.saveData(key: StorageKeys.fcmToken, value: fcmToken);
      } else {
        logError("Failed to get FCM token on Android");
      }
    } else if (Platform.isIOS) {
      // Wait for APNS token to become available (background, non-blocking)
      String? apnsToken;
      for (int i = 0; i < 5 && (apnsToken == null || apnsToken.isEmpty); i++) {
        try {
          apnsToken = await messaging.getAPNSToken();
        } catch (e) {
          // ignore, retry
        }
        if (apnsToken == null || apnsToken.isEmpty) {
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (apnsToken != null && apnsToken.isNotEmpty) {
        logSuccess("APNS Token: $apnsToken");
      } else {
        logWarning("APNS token not available yet");
      }

      // Get FCM token
      for (int i = 0; i < 5 && (fcmToken == null || fcmToken.isEmpty); i++) {
        try {
          fcmToken = await messaging.getToken();
        } catch (e) {
          logWarning("getToken attempt ${i + 1} failed: $e");
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        logSuccess("iOS FCM Token: $fcmToken");
        await CacheHelper.saveData(key: StorageKeys.fcmToken, value: fcmToken);
      } else {
        logError("Failed to get FCM token on iOS");
      }
    }

    await DeviceTokenSync.sync();
  } catch (e) {
    logError("Error getting device token: $e");
  }
}
