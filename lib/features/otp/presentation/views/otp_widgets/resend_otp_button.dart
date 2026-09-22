import '../../../../../main_importants.dart';
import '../../view_model/otp_cubit.dart';
import '../../view_model/otp_states.dart';

class ResendOtpButton extends StatefulWidget {
  const ResendOtpButton({super.key, this.onPressed, this.showResend, this.secondsRemaining});
  final void Function()? onPressed;
  final bool? showResend;
  final int? secondsRemaining;
  @override
  State<ResendOtpButton> createState() => _ResendOtpButtonState();
}

class _ResendOtpButtonState extends State<ResendOtpButton> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit,OtpStates>(
      listener: (context,state){
        if(state is ResendOtpSuccessState){
          CherryToast.success(
            toastDuration: const Duration(seconds: 10),
            title: Text(state.resendOtpModel.message! +
                state.resendOtpModel.data!.code.toString(),
                style: const TextStyle(color: AppColors.mainColor)),
          ).show(context);
        }
        if(state is ResendOtpErrorState){
          CherryToast.error(
            title: Text(
              state.error.toString(),
              style: const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
        }
      },
      builder:  (context,state){
        return Center(
          child:widget.showResend!
              ? ConditionalBuilder(
            condition: state is ! ResendOtpLoadingState,
            fallback: (context)=>const CustomLoading(),
            builder: (context){
              return TextButton(
                onPressed: widget.onPressed,
                child: const Text(
                  "Resend Code",
                  style: TextStyle(color: AppColors.mainColor),
                ),
              );
            },

          )
              : Text(
            "Resend code in ${widget.secondsRemaining} s",
            style: const TextStyle(color: Colors.grey),
          ),
        );
      },

    );
  }
}
