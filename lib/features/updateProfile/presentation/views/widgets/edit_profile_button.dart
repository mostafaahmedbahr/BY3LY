import 'package:by3ly/core/utils/app_nav/new_app_nav.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/layout/presentation/views/layout_view.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Gold Save CTA — matches every other primary action in the app.
class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileDataCubit, UpdateProfileDataStates>(
      listener: (context, state) {
        if (state is UpdateProfileDataErrorState) {
          Toast.showErrorToast(
            msg: state.error == 'nothingToSend'
                ? context.tr(LocaleKeys.noChangesToSave)
                : state.error,
            context: context,
          );
        }
        if (state is UpdateProfileDataSuccessState) {
          final msg = state.updateProfileDataModel.message?.trim();
          Toast.showSuccessToast(
            msg: (msg != null && msg.isNotEmpty)
                ? msg
                : context.tr(LocaleKeys.done),
            context: context,
          );
          // Refresh cached profile then navigate back to home.
          try {
            context.read<ProfileCubit>().getProfile();
          } catch (_) {}
          NewAppNav.customNavigator(
            context: context,
            screen: const LayoutView(),
            finish: true,
          );
        }
      },
      builder: (context, state) {
        final busy = state is UpdateProfileDataLoadingState;

        return SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.yellowColor,
                  Color(0xffE08B1B),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: busy
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.yellowColor
                            .withValues(alpha: 0.40),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: busy
                    ? null
                    : () {
                        if (
                            formKey.currentState != null &&
                            !formKey.currentState!.validate()) {
                          return;
                        }
                        final updateProfileDataCubit =
                            UpdateProfileDataCubit.get(context);
                        updateProfileDataCubit.updateProfileData(
                          image: updateProfileDataCubit.profileImage,
                          email: updateProfileDataCubit.emailCon.text.isNotEmpty
                              ? updateProfileDataCubit.emailCon.text
                              : null,
                          fullName:
                              updateProfileDataCubit.nameCon.text.isNotEmpty
                                  ? updateProfileDataCubit.nameCon.text
                                  : null,
                          phoneNumber:
                              updateProfileDataCubit.phoneCon.text.isNotEmpty
                                  ? updateProfileDataCubit.phoneCon.text
                                  : null,
                        );
                      },
                child: Center(
                  child: busy
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Color(0xff1A1205),
                          ),
                        )
                      : Text(
                          context.tr(LocaleKeys.save),
                          style: const TextStyle(
                            color: Color(0xff1A1205),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
