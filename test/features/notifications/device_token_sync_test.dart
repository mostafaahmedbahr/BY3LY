import 'package:by3ly/core/app_services/remote_services/end_points.dart';
import 'package:by3ly/core/notifications/device_token_sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no device-token endpoint is assumed without build configuration', () {
    expect(EndPoints.updateDeviceToken, isEmpty);
    expect(DeviceTokenSync.isConfigured, isFalse);
  });

  test('only the confirmed login/verifyCode contracts carry device_token', () {
    expect(EndPoints.login, 'login');
    expect(EndPoints.verifyCode, 'verifyCode');
  });
}
