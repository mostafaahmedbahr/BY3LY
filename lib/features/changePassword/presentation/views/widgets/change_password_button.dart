import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../../../layout/presentation/view_model/layout_cubit.dart';
import '../../view_model/change_password_cubit.dart';
import '../../view_model/change_password_states.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({
    super.key,
    required this.formKey,
    required this.screenName,
  });

  final GlobalKey<FormState> formKey;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
      buildWhen: (previous, current) {
        return current is ChangePasswordSuccessState ||
            current is ChangePasswordErrorState ||
            current is ChangePasswordLoadingState;
      },
      listener: (context, state) {
        if (state is ChangePasswordSuccessState) {
          Toast.showSuccessToast(
            msg: state.changePasswordModel.message.toString(),
            context: context,
          );
          context.pushNamedAndRemoveAll(Routes.loginView);
          context.read<ChangePasswordCubit>().clearUserData();
        context.read<LayoutCubit>().changeBottomNav(0, context);
        }
        if (state is ChangePasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ChangePasswordLoadingState,
          fallback: (context) => const CustomLoading(),
          builder: (context) {
            return CustomButton(

              btnText:Text( LocaleKeys.changePassword.tr() ,style: AppStyles.textStyle14W500White,),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<ChangePasswordCubit>().changePassword(
                    screenName: screenName,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
