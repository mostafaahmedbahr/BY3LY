import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:by3ly/core/shared_cubits/auth_cubit/auth_states.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:by3ly/core/utils/token_migration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const secureChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  late Map<String, Object?> secureValues;

  setUp(() async {
    secureValues = <String, Object?>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, (call) async {
          String keyOf(dynamic args) => args is String
              ? args
              : (args as Map<dynamic, dynamic>)['key'] as String;

          switch (call.method) {
            case 'read':
              return secureValues[keyOf(call.arguments)];
            case 'write':
              final args = call.arguments as Map<dynamic, dynamic>;
              secureValues[keyOf(args)] = args['value'] as String;
              return null;
            case 'delete':
              secureValues.remove(keyOf(call.arguments));
              return null;
            case 'deleteAll':
              secureValues.clear();
              return null;
            default:
              return null;
          }
        });
    CacheTokenManger.userToken = null;
  });

  tearDown(() async {
    CacheTokenManger.userToken = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, null);
  });

  test('migration imports a legacy plaintext token then removes it', () async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.userToken: 'legacy-token',
    });
    await CacheHelper.init();

    await TokenMigration.migrateLegacyToken();

    expect(CacheTokenManger.userToken, 'legacy-token');
    expect(secureValues['userToken'], 'legacy-token');
    expect(CacheHelper.getData(key: StorageKeys.userToken), isNull);
  });

  test('migration never overwrites an existing secure token', () async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.userToken: 'legacy-token',
    });
    await CacheHelper.init();
    secureValues['userToken'] = 'secure-token';

    await TokenMigration.migrateLegacyToken();

    expect(secureValues['userToken'], 'secure-token');
    expect(CacheHelper.getData(key: StorageKeys.userToken), isNull);
  });

  test(
    'AuthCubit reads the session from the secure-backed token manager',
    () async {
      SharedPreferences.setMockInitialValues({StorageKeys.isGuest: false});
      await CacheHelper.init();
      CacheTokenManger.userToken = 'secure-token';

      final cubit = AuthCubit()..checkAuthStatus();

      expect(cubit.userToken, 'secure-token');
      expect(cubit.state, isA<AuthLoggedInState>());
    },
  );

  test('AuthCubit never writes a plaintext token copy', () async {
    SharedPreferences.setMockInitialValues({StorageKeys.isGuest: true});
    await CacheHelper.init();

    final cubit = AuthCubit()..loginWithToken('secure-token');

    expect(cubit.userToken, 'secure-token');
    expect(CacheHelper.getData(key: StorageKeys.userToken), isNull);
  });

  test('clearUserData also removes any legacy plaintext token', () async {
    SharedPreferences.setMockInitialValues({StorageKeys.userToken: 'legacy'});
    await CacheHelper.init();

    await CacheHelper.clearUserData();

    expect(CacheHelper.getData(key: StorageKeys.userToken), isNull);
  });
}
