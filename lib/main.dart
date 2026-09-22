import 'package:easy_localization/easy_localization.dart';
import 'core/utils/app_initializer.dart';
import 'lang/codegen_loader.g.dart';
import 'main_importants.dart';
import 'my_app.dart';

void main() async {
  await AppInitializer.init();

  runApp(EasyLocalization(
     startLocale: const Locale('ar',""),
      supportedLocales: const [
        Locale('ar',""),
        Locale('en',""),
      ],
      path: 'assets/lang',
      saveLocale: true,
      fallbackLocale: const Locale('en',""),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child:  const MyApp()
  ),);
}


