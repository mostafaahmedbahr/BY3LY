import 'package:easy_localization/easy_localization.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../../main_importants.dart';
import '../view_model/on_boarding_cubit.dart';
import '../view_model/on_boarding_states.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    logSuccess(CacheTokenManger.userToken);
    logSuccess("OnBoardingView");
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => OnBoardingCubit(),
        child: BlocBuilder<OnBoardingCubit, OnBoardingStates>(
          builder: (context, state) {
            return IntroductionScreen(
              pages: OnBoardingCubit.get(context).list,
              showSkipButton: true,
              skip: Text(
                context.tr(LocaleKeys.skip),
                style: TextStyle(
                  color: AppColors.yellowColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              next: Icon(Icons.arrow_forward, color: AppColors.accent),
              done: Text(
                context.tr(LocaleKeys.done),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              onDone: () {
                context.pushNamedAndRemoveAll(Routes.loginView);
              },
              onSkip: () {
                context.pushNamedAndRemoveAll(Routes.loginView);
              },
              dotsDecorator: DotsDecorator(
                size: Size(10.0.w, 10.0.h),
                color: AppColors.textSecondary,
                activeSize: Size(22.0.w, 10.0.h),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0.r),
                ),
                activeColor: AppColors.accent,
              ),
            );
          },
        ),
      ),
    );
  }
}
