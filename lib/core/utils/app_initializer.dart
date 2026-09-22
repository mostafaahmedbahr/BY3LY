import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main_importants.dart';
import '../utils/bloc_observer.dart';
import '../../firebase_options.dart';
import 'get_device_token.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 🔹 Init Cache
    await CacheHelper.init();

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

    // 🔹 Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 🔹 Device Token
    await getDeviceToken();

    // 🔹 Dependency Injection
    setup();

    // 🔹 Bloc Observer
    Bloc.observer = SimpleBlocObserver();
  }
}