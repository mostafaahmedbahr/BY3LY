import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../view_model/login_cubit.dart';
import '../../view_model/login_states.dart';

class LoginButtonsWidget extends StatelessWidget {
  const LoginButtonsWidget({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          context.pushNamedAndRemoveAll(Routes.layoutView);
          Toast.showSuccessToast(
              msg: state.loginModel.message!, context: context);
        } else if (state is LoginSuccessWithNoActiveState) {
          context.pushNamed(Routes.otpView,
              arguments: CacheHelper.getData(key: "email"));
          Toast.showSuccessToast(
              duration: const Duration(seconds: 10),
              msg:
              "${LocaleKeys.theActivationCodeHasBeenSentToYourEmailAddress.tr()} "
                  "${LocaleKeys.code.tr()} : ${state.code}",
              context: context);
        } else if (state is LoginErrorState) {
          Toast.showErrorToast(msg: state.error, context: context);
        }
      },
      builder: (context, state){
        var loginCubit = context.read<LoginCubit>();
        return IgnorePointer(
          ignoring : state is LoginLoadingState,
          child: Column(
            children: [
              ConditionalBuilder(
                condition: state is! LoginLoadingState,
                fallback: (context) => const CustomLoading(),
                builder: (context) {
                  return CustomButton(
                    btnText: Text(
                      context.tr(LocaleKeys.login),
                      style: AppStyles.textStyle14W500White,
                    ),
                    onPressed: () {
                      // loginCubit.emailCon.text = "newtest@gmail.com";
                      // loginCubit.passwordCon.text = "Mm@123456";
                      // loginCubit.emailCon.text = "mt@gmail.com";
                      // loginCubit.passwordCon.text = "Mm@123456";
                      loginCubit.emailCon.text = "test0@example.com";
                      loginCubit.passwordCon.text = "12345678";
                      if (formKey.currentState!.validate()) {
                        loginCubit.login(
                          // phone: loginCubit.phoneCon.text,
                          email: loginCubit.emailCon.text,
                          password: loginCubit.passwordCon.text,
                        );
                      }
                    },
                  );
                },
              ),
              Gap(20.h),
              CustomButton(
                btnText: Text(
                  context.tr(LocaleKeys.register),
                  style: AppStyles.textStyle14W500White,
                ),
                onPressed: () {
                  context.pushNamed(Routes.registerView);
                },
              ),
              Padding(
                padding: EdgeInsets.all(10.0.r),
                child: Text(
                  context.tr(LocaleKeys.or),
                  style: AppStyles.textStyle12W600Gary,
                ),
              ),
              CustomButton(
                borderColor: AppColors.mainColor,
                btnColor: AppColors.whiteColor,
                btnText: Text(
                  context.tr(LocaleKeys.loginLater),
                  style: AppStyles.textStyle14W500White.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
                onPressed: () {
                  context.pushNamed(Routes.layoutView);
                  context.read<AuthCubit>().loginAsGuest();
                },
              ),
            ],
          ),
        );
      },

    );
  }
}
