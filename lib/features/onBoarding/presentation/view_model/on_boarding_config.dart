import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

/// Static onboarding content — same three slides, now typed and shared.
class OnBoardingConfig {
  const OnBoardingConfig({
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String Function() title;
  final String Function() body;
}

List<OnBoardingConfig> onBoardingSlides() => [
      OnBoardingConfig(
        image: AppImages.onBoarding1,
        title: () => LocaleKeys.youWillSellAndFindEverything.tr(),
        body: () => LocaleKeys.enjoySafeAndReliableShoppingExperience.tr(),
      ),
      OnBoardingConfig(
        image: AppImages.onBoarding2,
        title: () => LocaleKeys.easyAndFastPurchaseProcess.tr(),
        body: () => LocaleKeys.compareProductsBeforeBuying.tr(),
      ),
      OnBoardingConfig(
        image: AppImages.onBoarding3,
        title: () => LocaleKeys.startYourBusinessNow.tr(),
        body: () => LocaleKeys.easiestWayToStartOnlineBusiness.tr(),
      ),
    ];
