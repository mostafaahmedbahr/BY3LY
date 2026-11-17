import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../app_services/local_services/cache_helper.dart';
import '../app_services/local_services/cache_token.dart';
import '../app_services/remote_services/api_service.dart';
import '../app_services/remote_services/end_points.dart';
import '../app_services/remote_services/service_locator.dart';
import '../extensions/log.dart';
import '../utils/app_consts/storage_keys.dart';
import '../utils/guest_guard.dart';

/// Keeps the backend's stored FCM token up to date.
///
/// Syncs on app start, on token rotation and right after login/OTP success.
/// The last successfully synced token is persisted so a failed request is
/// retried on the next trigger instead of being silently skipped forever.
class DeviceTokenSync {
  DeviceTokenSync._();

  static String? _lastSyncedToken;
  static Future<void>? _inFlight;

  /// True only when a real backend endpoint was supplied at build time.
  static bool get isConfigured => EndPoints.updateDeviceToken.trim().isNotEmpty;

  /// Prevents duplicate POSTs when startup, token refresh and login all fire
  /// at the same time.
  static Future<void> sync({bool force = false}) async {
    final Future<void>? running = _inFlight;
    if (running != null) {
      await running;
      if (!force) return;
    }

    final Future<void> future = _sync(force: force);
    _inFlight = future;
    try {
      await future;
    } finally {
      if (identical(_inFlight, future)) _inFlight = null;
    }
  }

  static Future<void> _sync({required bool force}) async {
    // No Firebase (e.g. unit tests) means there is no FCM token to sync.
    if (Firebase.apps.isEmpty) return;

    // Guests and logged-out users have no backend record to update.
    if (GuestGuard.isGuest) return;
    final String? userToken = CacheTokenManger.userToken;
    if (userToken == null || userToken.isEmpty) return;

    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      logError('DeviceTokenSync: could not read FCM token: $e');
    }
    token ??= CacheHelper.getData(key: StorageKeys.fcmToken)?.toString();
    if (token == null || token.isEmpty) return;

    // Always keep the freshest token locally so login/OTP can send it too.
    await CacheHelper.saveData(key: StorageKeys.fcmToken, value: token);

    if (!isConfigured) {
      logWarning(
        'DeviceTokenSync: no verified backend endpoint configured; '
        'token kept locally. Supply FCM_UPDATE_ENDPOINT once the backend '
        'contract is confirmed.',
      );
      return;
    }

    final String? lastPersisted = CacheHelper.getData(
      key: StorageKeys.fcmTokenSynced,
    )?.toString();
    if (!force && _lastSyncedToken == token && lastPersisted == token) return;

    try {
      final response = await getIt<ApiService>().postData(
        endPoint: EndPoints.updateDeviceToken,
        data: jsonEncode({'device_token': token}),
      );
      if (!_isSuccess(response.data)) {
        throw Exception(
          'Server rejected the token update: ${_messageOf(response.data)}',
        );
      }
      _lastSyncedToken = token;
      await CacheHelper.saveData(key: StorageKeys.fcmTokenSynced, value: token);
      logSuccess('DeviceTokenSync: FCM token synced with the backend.');
    } catch (e) {
      // Leave _lastSyncedToken null so the next trigger retries this token.
      _lastSyncedToken = null;
      logError(
        'DeviceTokenSync: failed to sync token to '
        '"${EndPoints.updateDeviceToken}": $e',
      );
    }
  }

  /// Laravel-style envelopes sometimes answer 2xx with `status: false`.
  static bool _isSuccess(dynamic body) {
    if (body == null) return true;
    if (body is! Map) return true;
    final dynamic status = body['status'];
    if (status is bool) return status;
    if (status is num) return status == 1;
    if (status is String) {
      return status == '1' || status.toLowerCase() == 'true';
    }
    return true;
  }

  static String _messageOf(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
    return body?.toString() ?? 'empty response';
  }
}
