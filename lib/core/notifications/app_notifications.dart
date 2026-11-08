import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../../my_app.dart';
import '../app_services/local_services/cache_helper.dart';
import '../app_services/local_services/cache_token.dart';
import '../routing/routes.dart';
import '../utils/app_consts/storage_keys.dart';
import '../utils/guest_guard.dart';
import '../../features/notifications/presentation/view_model/notifications_cubit.dart';
import 'device_token_sync.dart';
import 'notification_service.dart';

/// Top-level FCM background handler. Must be registered with
/// `FirebaseMessaging.onBackgroundMessage` before `runApp`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  debugPrint('FCM background message: ${message.messageId}');

  // `notification` payloads are displayed by the system while the app is in
  // the background/terminated. Data-only messages need a local notification
  // (Android only: iOS cannot show one from a background isolate).
  if (message.notification != null) return;
  if (!Platform.isAndroid) return;

  try {
    await NotificationService.instance.showRemoteMessage(message);
  } catch (e) {
    debugPrint('Background notification failed: $e');
  }
}

/// Wires FCM into the app: foreground display, tap navigation, iOS foreground
/// presentation and token-refresh syncing.
class AppNotifications {
  AppNotifications._();

  /// True when a notification launched the app and we still need to open the
  /// notifications screen (the splash screen owns navigation for ~4s).
  static bool _pendingNavigation = false;

  static Future<void> initialize() async {
    try {
      await NotificationService.instance.initialize(
        onTap: (_) => _navigateToNotifications(),
      );
    } catch (e) {
      debugPrint('Local notifications initialization failed: $e');
    }

    try {
      // iOS: let the system display `notification` payloads in foreground.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      debugPrint('Foreground presentation options failed: $e');
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((_) {
      _navigateToNotifications();
    });

    // Keep the backend in sync when the FCM token rotates.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await CacheHelper.saveData(key: StorageKeys.fcmToken, value: token);
      await DeviceTokenSync.sync(force: true);
    });

    await DeviceTokenSync.sync();
  }

  /// Call once after the first frame. Handles the "app was terminated and the
  /// user tapped a notification" case.
  static Future<void> handleInitialMessage() async {
    try {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      final launch = await NotificationService.instance.getLaunchDetails();
      final launchedFromNotification =
          message != null || (launch?.didNotificationLaunchApp ?? false);
      if (!launchedFromNotification) return;

      // Don't push the notifications screen for guests / logged-out users.
      if (GuestGuard.isGuest) return;
      final userToken = CacheTokenManger.userToken;
      if (userToken == null || userToken.isEmpty) return;

      // The splash screen replaces the top route after its animation; defer
      // until LayoutView is on screen so the notifications screen isn't lost.
      _pendingNavigation = true;
    } catch (e) {
      debugPrint('AppNotifications.handleInitialMessage failed: $e');
    }
  }

  /// Returns true once when the app was opened from a notification.
  /// [LayoutView] calls this after its first frame.
  static bool consumePendingNavigation() {
    if (!_pendingNavigation) return false;
    _pendingNavigation = false;
    return true;
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('FCM foreground message: ${message.messageId}');
    // iOS displays `notification` payloads itself (presentation options above).
    if (Platform.isIOS && message.notification != null) {
      NotificationsCubit.activeInstance?.onNewNotificationArrived();
      return;
    }

    try {
      await NotificationService.instance.showRemoteMessage(message);
    } catch (e) {
      debugPrint('Foreground notification failed: $e');
    }
    // Show the local notification AND sync the in-app badge + list.
    NotificationsCubit.activeInstance?.onNewNotificationArrived();
  }

  static void _navigateToNotifications() {
    if (GuestGuard.isGuest) return;
    // Force the screen to refetch so the tapped notification appears
    // in the list and the badge (Home icon) matches the server count.
    NotificationsCubit.activeInstance?.markPendingUpdate();

    final navigator = MyApp.navigatorKey.currentState;
    if (navigator == null) {
      _pendingNavigation = true;
      return;
    }
    navigator.pushNamed(Routes.notificationsView);
  }
}
