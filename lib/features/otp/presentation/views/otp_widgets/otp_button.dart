import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../view_model/otp_cubit.dart';
import '../../view_model/otp_states.dart';

class OtpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String email;

  const OtpButton({
    super.key,
    required this.formKey,
    required this.controller,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpStates>(
      listener: (context, state) {
        if (state is VerifyOtpSuccessState) {
          // Sync AuthCubit so app treats user as logged-in (splash/guard logic)
          final token = state.otpModel.data?.resolvedToken ?? '';
          if (token.isNotEmpty && token != "null") {
            context.read<AuthCubit>().loginWithToken(token);
          }
          // Fetch fresh profile right after activation.
          try {
            context.read<ProfileCubit>().getProfile();
          } catch (_) {}
          Toast.showSuccessToast(msg: state.otpModel.message!, context: context);
          context.pushNamedAndRemoveAll(Routes.chooseLocationView);
        }  else if (state is VerifyOtpErrorState) {
          Toast.showErrorToast(msg:  state.error.toString(),context: context);
        }
      },
      builder: (context, state) {
        return state is VerifyOtpLoadingState
            ? const CustomLoading()
            : CustomButton(
          btnColor: AppColors.mainColor,
          btnText: Text(
            context.tr(LocaleKeys.confirm),
            style: AppStyles.textStyle16W600Black.copyWith(color: Colors.white),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
               context.read<OtpCubit>().verifyOtp(
                otp: controller.text,
                email: email.isEmpty ? CacheHelper.getData(key: "email") : email,
              );
            }
          },
        );
      },
    );
  }
}
