import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../main_importants.dart';
import '../../../../changeLang/presentation/views/change_lang_view.dart';
import '../../../../deleteAccount/presentation/views/delete_account_view.dart';
import '../../../../helpSupport/presentation/views/help_support_view.dart';
import '../../../../privacy/presentation/views/privacy_view.dart';
import 'compact_settings_tile.dart';
import 'logout.dart';
import 'theme_mode_switch.dart';

class SettingsListWidget extends StatelessWidget {
  const SettingsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            context.tr(LocaleKeys.settings),
            style: AppStyles.textStyle16W500Black.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mainColor.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              // الدعم والمساعدة
              CompactSettingsTile(
                title: LocaleKeys.reportingAndSupport.tr(),
                iconData: CupertinoIcons.headphones,
                onTap: () => _push(context, const HelpSupportView()),
              ),
              const SettingsDivider(),

              // الخصوصية / حجب الرقم
              CompactSettingsTile(
                title: LocaleKeys.privacy.tr(),
                imagePath: AppImages.shield,
                onTap: () => _push(context, const PrivacyView()),
              ),
              const SettingsDivider(),

              // تغيير كلمة المرور
              CompactSettingsTile(
                title: LocaleKeys.changePassword.tr(),
                imagePath: AppImages.lock,
                onTap: () => context.pushNamed(Routes.changePasswordView),
              ),
              const SettingsDivider(),

              // تغيير اللغة
              CompactSettingsTile(
                title: LocaleKeys.changeLang.tr(),
                imagePath: AppImages.lang,
                onTap: () => showChangeLangSheet(context),
              ),
              const SettingsDivider(),

              // المظهر
              const ThemeModeSwitch(),
              const SettingsDivider(),

              // الإشعارات
              BlocConsumer<ProfileCubit, ProfileStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return CompactSettingsTile(
                    title: LocaleKeys.notifications.tr(),
                    imagePath: AppImages.notification,
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppColors.mainColor,
                      value: ProfileCubit.get(context).switchValue,
                      onChanged: (value) {
                        ProfileCubit.get(context)
                            .changeNotificationValue(value);
                      },
                    ),
                  );
                },
              ),
              const SettingsDivider(),

              // معلومات قانونية (قابلة للطي: عن التطبيق / الشروط / الخصوصية)
              // Material هنا مهم: الكارت الخارجي DecoratedBox، ومن غير Material
              // هتبقى الـ ink splash بتاعة الـ ListTile (اللي جوه ExpansionTile)
              // مخفية ورا الكارت — وده الـ warning اللي بيحصل.
              Material(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExpansionTile(
                visualDensity: VisualDensity.compact,
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.only(bottom: 4),
                dense: true,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppImages.bookOpen,
                    width: 19,
                    height: 19,
                    colorFilter: ColorFilter.mode(
                      AppColors.mainColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  LocaleKeys.legalInfo.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textStyle14W500Black.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  LocaleKeys.legalInfoMsg.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textStyle10W400Gray.copyWith(fontSize: 9.5),
                ),
                trailing: Icon(
                  Icons.expand_more_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                children: [
                  CompactSettingsTile(
                    title: LocaleKeys.aboutApp.tr(),
                    imagePath: AppImages.globe,
                    onTap: () => context.pushNamed(Routes.aboutView),
                  ),
                  CompactSettingsTile(
                    title: LocaleKeys.termsAndConditions.tr(),
                    imagePath: AppImages.bookOpen,
                    onTap: () => context.pushNamed(Routes.termsView),
                  ),
                  CompactSettingsTile(
                    title: LocaleKeys.privacyPolicy.tr(),
                    imagePath: AppImages.shield,
                    onTap: () => context.pushNamed(Routes.privacyPolicyView),
                  ),
                ],
                  ),
                ),
              ),
              const SettingsDivider(),

              // حذف الحساب (داخل الكارت — بدون subtitle)
              CompactSettingsTile(
                title: LocaleKeys.deleteAccount.tr(),
                imagePath: AppImages.trash,
                tintColor: AppColors.redColor,
                onTap: () => _push(context, const DeleteAccountView()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Logout(),
      ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: page),
    );
  }
}
