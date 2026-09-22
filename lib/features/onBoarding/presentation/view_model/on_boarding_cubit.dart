import 'package:easy_localization/easy_localization.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../../main_importants.dart';
import 'on_boarding_states.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit() : super(OnBoardingInitState());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  final List<PageViewModel> list = [
    PageViewModel(
      title: LocaleKeys.youWillSellAndFindEverything.tr(),
      body: LocaleKeys.enjoySafeAndReliableShoppingExperience.tr(),
      image: Image.asset(AppImages.onBoarding1),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.mainColor,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    ),
    PageViewModel(
      title: LocaleKeys.easyAndFastPurchaseProcess.tr(),
      body: LocaleKeys.compareProductsBeforeBuying.tr(),
      image: Image.asset(AppImages.onBoarding2),
      decoration: PageDecoration(
        titleTextStyle:   TextStyle(
          color: AppColors.mainColor,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        bodyTextStyle:   TextStyle(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    ),
    PageViewModel(
      title: LocaleKeys.startYourBusinessNow.tr(),
      body: LocaleKeys.easiestWayToStartOnlineBusiness.tr(),
      image: Image.asset(AppImages.onBoarding3),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.mainColor,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    ),
  ];
}
