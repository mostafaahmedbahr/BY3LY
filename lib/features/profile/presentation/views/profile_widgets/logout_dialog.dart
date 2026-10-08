import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../layout/presentation/view_model/layout_cubit.dart';
import '../../view_model/profile_cubit.dart';
import '../../view_model/profile_states.dart';

void showLogoutDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (dialogContext) => BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          // Cubit already cleared token + profileModel + CacheHelper.
          // Sync Auth state + reset nav, then go to login.
          try {
            context.read<AuthCubit>().logout();
          } catch (_) {}
          try {
            context.read<ProfileCubit>().clearProfile();
          } catch (_) {}
          CacheTokenManger.userToken = null;
          Toast.showSuccessToast(msg: state.logoutModel.message!, context: context);
          LayoutCubit.pageIndex = 0;
          context.pushNamedAndRemoveAll(Routes.loginView);
        } else if (state is LogoutErrorState) {
          Toast.showErrorToast(msg: state.error.toString(), context: context);
        }
      },
      builder: (context, state) {
        var profileCubit = context.read<ProfileCubit>();
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.confirmLogout.tr()),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(LocaleKeys.areYouSureLogout.tr()),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                profileCubit.logout();
              },
              child: state is LogoutLoadingState
                  ?   SizedBox(height: 30.h, width: 30.w, child: CustomLoading())
                  : Text(
                LocaleKeys.logout.tr(),
                      style: const TextStyle(color: AppColors.redColor),
                    ),
            ),
          ],
        );
      },
    ),
  );
}
