import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../app_services/local_services/cache_helper.dart';
import '../app_services/local_services/cache_token.dart';
import '../app_services/remote_services/api_service.dart';
import '../app_services/remote_services/end_points.dart';
import '../app_services/remote_services/service_locator.dart';
import '../utils/app_consts/storage_keys.dart';
import '../utils/guest_guard.dart';

/// Keeps the backend's stored FCM token up to date.
///
/// The current backend only accepts `device_token` during login and has no
/// dedicated update endpoint, so [updateEndpoint] is null and refreshed tokens
/// are stored locally. Point it at the endpoint (for example
/// `'updateDeviceToken'`) once the backend exposes one and the sync will start
/// automatically on app start and on every token refresh.
class DeviceTokenSync {
  DeviceTokenSync._();

  /// Backend path that accepts `{ "device_token": "..." }`.
  /// Null = the backend does not expose one yet.
  static const String? updateEndpoint = EndPoints.updateDeviceToken;

  static String? _lastSyncedToken;

  static Future<void> sync({bool force = false}) async {
    if (GuestGuard.isGuest) return;
    final userToken = CacheTokenManger.userToken;
    if (userToken == null || userToken.isEmpty) return;

    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('DeviceTokenSync: could not read FCM token: $e');
    }
    token ??= CacheHelper.getData(key: StorageKeys.fcmToken)?.toString();
    if (token == null || token.isEmpty) return;

    await CacheHelper.saveData(key: StorageKeys.fcmToken, value: token);

    if (!force && _lastSyncedToken == token) return;

    if (updateEndpoint == null) {
      debugPrint(
        'DeviceTokenSync: no update endpoint configured; token kept locally.',
      );
      _lastSyncedToken = token;
      return;
    }

    try {
      await getIt<ApiService>().postData(
        endPoint: updateEndpoint!,
        data: jsonEncode({'device_token': token}),
      );
      _lastSyncedToken = token;
    } catch (e) {
      debugPrint('DeviceTokenSync: update failed: $e');
    }
  }
}
