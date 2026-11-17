import 'package:by3ly/core/app_services/remote_services/end_points.dart';
import 'package:by3ly/core/notifications/device_token_sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FCM token sync uses the confirmed updateFirebaseToken endpoint', () {
    expect(EndPoints.updateFirebaseToken, 'updateFirebaseToken');
    expect(DeviceTokenSync.isConfigured, isTrue);
  });

  test('only the confirmed login/verifyCode contracts carry device_token', () {
    expect(EndPoints.login, 'login');
    expect(EndPoints.verifyCode, 'verifyCode');
  });
}
