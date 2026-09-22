import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:by3ly/features/profile/presentation/views/profile_widgets/settings_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../main_importants.dart';
import '../../../../changeLang/presentation/views/change_lang_view.dart';
import '../../../../deleteAccount/presentation/views/delete_account_view.dart';
import '../../../../privacy/presentation/views/privacy_view.dart';
import 'logout.dart';

class SettingsListWidget extends StatelessWidget {
  const SettingsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(LocaleKeys.settings),
          style: AppStyles.textStyle16W500Black,
        ),
        Gap(10.h),
        SettingsItemWidget(
          title: LocaleKeys.privacy.tr(),
          subTitle: LocaleKeys.blockPhoneNumber.tr(),
          image: AppImages.shield,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const PrivacyView(),
              ),
            );
          },
        ),
        SettingsItemWidget(
          title: LocaleKeys.changeLang.tr(),
          subTitle: LocaleKeys.changeLangYouWant.tr(),
          image: AppImages.lang,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const ChangeLangView(),
              ),
            );
          },
        ),
        /// change password
        SettingsItemWidget(
          title: LocaleKeys.changePassword.tr(),
          subTitle: LocaleKeys.changePasswordMsg.tr(),
          image: AppImages.lock,
          onTap: () {
            context.pushNamed(Routes.changePasswordView);
          },
        ),
        SettingsItemWidget(
          title: LocaleKeys.deleteAccount.tr(),
          subTitle: LocaleKeys.deleteAccountAndStopAds.tr(),
          image: AppImages.trash,
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const DeleteAccountView(),
              ),
            );
          },
        ),
        BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                shadowColor: AppColors.mainColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF8F8F8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.notification,
                      ),
                      const CustomSizedBox(
                        width: 8,
                      ),
                      const CustomSizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.notifications.tr(),
                              style: AppStyles.textStyle14W500White.copyWith(
                                color: AppColors.blackColor,
                              )),
                          Text(
                              ProfileCubit.get(context).switchValue == false
                                  ? LocaleKeys.enableNotifications.tr()
                                  : LocaleKeys.disableNotifications.tr(),
                              style: AppStyles.textStyle10W400Gray),
                        ],
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        activeColor: AppColors.mainColor,
                        value: ProfileCubit.get(context).switchValue,
                        onChanged: (value) {
                          ProfileCubit.get(context)
                              .changeNotificationValue(value);
                        },
                      ),
                      const CustomSizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // SettingsItemWidget(
        //   title: 'الاشعارات',
        //   subTitle: "تفعيل الاشعارات",
        //   image: AppImages.notification,
        //   onTap: (){},
        // ),
        const Gap(10),
        Logout(),

      ],
    );
  }
}
