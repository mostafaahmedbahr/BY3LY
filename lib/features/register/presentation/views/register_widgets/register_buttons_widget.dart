import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../view_model/register_cubit.dart';
import '../../view_model/register_states.dart';

class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      buildWhen: (previous, current) {
        return current is ClearDataSuccess ||
        current is SignUpLoading ||
        current is SignUpSuccess ||
        current is SignUpError;
      },
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Toast.showSuccessToast(
              duration: const Duration(seconds: 10),
              msg: state.registerModel.message! +
                  state.registerModel.data!.code.toString(),
              context: context);
          context.pushNamed(Routes.otpView,
            arguments: state.registerModel.data!.user!.email,
          );
          context.read<RegisterCubit>().clearData();
        } else if (state is SignUpError) {
           Toast.showErrorToast(msg: state.message, context: context);
        }
      },
      builder: (context, state) {
        var registerCubit = RegisterCubit.get(context);
        return Column(
          children: [
            state is SignUpLoading
                ? const CustomLoading()
                : CustomButton(
                    btnColor: AppColors.mainColor,
                    btnText: Text(
                      context.tr(LocaleKeys.register2),
                      style: AppStyles.textStyle16W600Black
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      // context.pushNamed(Routes.chooseLocationView,);
                      if (formKey.currentState!.validate()) {
                        registerCubit.signUp(
                          name: registerCubit.nameCon.text,
                          password: registerCubit.passCon.text,
                          email: registerCubit.emailCon.text,
                          age: registerCubit.ageCon.text,
                          phoneNumber: registerCubit.mobileCon.text,
                          image: registerCubit.profileImage,
                        );
                        // if (registerCubit.profileImage == null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //           context.tr(LocaleKeys.youNotUploadAnyImage)),
                        //     ),
                        //   );
                        // } else {
                        //   // context.pushNamed(Routes.chooseLocationView,);
                        //   registerCubit.signUp(
                        //     name: registerCubit.nameCon.text,
                        //     password: registerCubit.passCon.text,
                        //     email: registerCubit.emailCon.text,
                        //     phoneNumber: registerCubit.mobileCon.text,
                        //     image: registerCubit.profileImage,
                        //   );
                        // }
                      }
                    },
                  ),
          ],
        );
      },
    );
  }
}
