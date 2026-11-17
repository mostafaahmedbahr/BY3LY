import '../app_services/local_services/cache_helper.dart';
import '../app_services/local_services/cache_token.dart';
import '../app_services/local_services/secure_storage_service.dart';
import 'app_consts/storage_keys.dart';

/// One-time bridge for sessions created by older builds that stored the
/// Bearer token as plaintext in SharedPreferences.
///
/// It never overwrites an existing secure token, and always removes the
/// plaintext copy after the check so it cannot be re-imported later.
class TokenMigration {
  const TokenMigration._();

  static const String _secureTokenKey = 'userToken';

  static Future<void> migrateLegacyToken() async {
    final Object? legacy = CacheHelper.getData(key: StorageKeys.userToken);
    if (legacy is! String || legacy.isEmpty) return;

    final String? existing = await SecureStorageService.instance.readData(
      key: _secureTokenKey,
    );
    if (existing == null || existing.isEmpty) {
      await CacheTokenManger.saveUserToken(legacy);
    }
    await CacheHelper.removeData(key: StorageKeys.userToken);
  }
}
