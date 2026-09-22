import 'package:easy_localization/easy_localization.dart';
import '../../../main_importants.dart';
import '../../app_services/local_services/cache_helper.dart';
import '../../utils/app_consts/storage_keys.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_getSavedLocale());

  static Locale _getSavedLocale() {
    final savedLanguage = CacheHelper.getData(key: StorageKeys.language);
    if (savedLanguage != null) {
      return Locale(savedLanguage, '');
    }
    return const Locale('ar', '');
  }

  void changeLanguage(BuildContext context, Locale locale) {
    CacheHelper.saveData(key: StorageKeys.language, value: locale.languageCode);
    EasyLocalization.of(context)?.setLocale(locale);
    emit(locale);
  }
}