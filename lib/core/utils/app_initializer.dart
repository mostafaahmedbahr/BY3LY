import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main_importants.dart';
import '../utils/bloc_observer.dart';
import '../../firebase_options.dart';
import 'get_device_token.dart';
import 'token_migration.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 🔹 Firebase Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );
    // 🔹 Init Cache
    await CacheHelper.init();

    // 🔹 One-time migration: move any legacy plaintext token into secure
    // storage before the first-run cleanup can erase it.
    await TokenMigration.migrateLegacyToken();

    // 🔹 First Run Check (قبل أي حاجة)
    bool isFirstRun = await CacheHelper.getData(key: "firstRun") ?? true;

    if (isFirstRun) {
      const storage = FlutterSecureStorage();

      // ✅ مسح كل حاجة
      await storage.deleteAll(); // مهم جدًا لـ iOS (Keychain)
      await CacheHelper.clearUserData();

      // حفظ إن ده مش أول مرة
      await CacheHelper.saveData(key: "firstRun", value: false);

      logWarning("🔥 First Run → Cache Cleared");
    }

    // 🔹 دلوقتي بقى نقرأ التوكن
    String? token = await CacheTokenManger.getUserToken();
    logSuccess("Retrieved token: $token");

    // 🔹 Localization
    await EasyLocalization.ensureInitialized();

    // 🔹 Dependency Injection
    setup();

    // 🔹 Device Token (needs Firebase + DI for token syncing). Deferred until
    // after the first frame so permission prompts/retries never delay splash.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unawaited_futures
      getDeviceToken();
    });

    // 🔹 Bloc Observer
    Bloc.observer = SimpleBlocObserver();
  }
}
