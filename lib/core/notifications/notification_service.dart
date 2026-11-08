import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/app_colors/app_colors.dart';

/// Thin wrapper around [FlutterLocalNotificationsPlugin].
///
/// Android does not display FCM messages while the app is in the foreground,
/// so foreground (and data-only background) messages are re-displayed as
/// local notifications from here. iOS displays `notification` payloads itself
/// once `setForegroundNotificationPresentationOptions` is enabled.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String channelId = 'by3ly_notifications';
  static const String channelName = 'إشعارات BY3LY';
  static const String channelDescription =
      'إشعارات التطبيق العامة (عروض، رسائل، تحديثات)';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Called when the user taps a local notification while the app is running.
  void Function(String? payload)? onNotificationTap;

  Future<void> initialize({void Function(String? payload)? onTap}) async {
    onNotificationTap = onTap;
    await _ensureInitialized();
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('ic_notification');
    const darwinSettings = DarwinInitializationSettings(
      // FCM's requestPermission() already asks the user; don't ask twice.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call(response.payload);
      },
    );

    await _createChannel();
    _initialized = true;
  }

  Future<void> _createChannel() async {
    if (!Platform.isAndroid) return;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );
  }

  /// Shows a local notification for an FCM message.
  ///
  /// Supports both `notification` payloads and data-only messages. Returns
  /// `false` when the message has no title/body to display.
  Future<bool> showRemoteMessage(RemoteMessage message) async {
    final title = _firstNonEmpty([
      message.notification?.title,
      message.data['title'],
      message.data['subject'],
      message.data['heading'],
    ]);
    final body = _firstNonEmpty([
      message.notification?.body,
      message.data['body'],
      message.data['message'],
      message.data['content'],
      message.data['text'],
    ]);

    if (title == null && body == null) {
      debugPrint(
        'NotificationService: message ${message.messageId} has no title/body; '
        'skipped.',
      );
      return false;
    }

    await _ensureInitialized();

    await _plugin.show(
      id: _notificationId(message),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          icon: 'ic_notification',
          color: AppColors.mainColor,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          styleInformation: body == null ? null : BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
    return true;
  }

  Future<NotificationAppLaunchDetails?> getLaunchDetails() {
    return _plugin.getNotificationAppLaunchDetails();
  }

  static int _notificationId(RemoteMessage message) {
    final id = message.messageId;
    if (id != null && id.isNotEmpty) return id.hashCode & 0x7fffffff;
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}
