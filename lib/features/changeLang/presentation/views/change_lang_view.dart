import 'package:by3ly/core/extensions/lang.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors/app_colors.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../lang/locale_keys.dart';
import '../../../chat/presentation/view_model/chat_unread_cubit.dart';
import '../../../chooseLocation/presentation/view_model/choose_location_cubit.dart';
import '../../../fav/presentation/view_model/fav_cubit.dart';
import '../../../home/presentation/view_model/home_cubit.dart';
import '../../../notifications/presentation/view_model/notifications_cubit.dart';
import '../../../privacy/presentation/view_model/privacy_cubit.dart';
import '../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../reportProduct/presentation/view_model/report_product_cubit.dart';
import '../../../search/presentation/view_model/search_cubit.dart';
import '../../../seeAllBestView/presentation/view_model/sell_all_best_view_cubit.dart';
import '../view_model/change_lang_cubit.dart';

/// Shows the language picker as a modal bottom sheet (not a full page).
Future<void> showChangeLangSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => const ChangeLangSheet(),
  );
}

/// Re-fetches all the app's initial data after a language change,
/// so every screen shows data in the new language.
void refreshAllData(BuildContext context) {
  final isGuest = GuestGuard.isGuest;

  // Home (always).
  context.read<HomeCubit>().getHome();
  context.read<HomeCubit>().getBanners();

  // Shared lists (always).
  context.read<SearchCubit>().getAllProductsForSearch();
  context.read<ChooseLocationCubit>().getAllCitiesAndCenters();
  context.read<ReportProductCubit>().getAllComplaintsTypesData();
  context.read<SellAllBestViewCubit>().getSellAllBestView();

  // Account-scoped data (skip for guests to avoid 401s).
  if (!isGuest) {
    context.read<ProfileCubit>().getProfile();
    context.read<PrivacyCubit>().getSettings();
    context.read<FavCubit>().getFavData();
    context.read<NotificationsCubit>().refresh();
    context.read<ChatUnreadCubit>().refresh();
  }
}

/// Bottom sheet content for picking the language.
class ChangeLangSheet extends StatelessWidget {
  const ChangeLangSheet({super.key});

  Future<void> _pick(BuildContext context, Locale locale) async {
    final current = context.locale.languageCode;
    if (locale.languageCode == current) {
      Navigator.pop(context);
      return;
    }
    context.read<LanguageCubit>().changeLanguage(context, locale);
    // Saved first, so the Dio interceptor now sends the new language.
    // Re-run all initial fetches immediately.
    refreshAllData(context);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.changeLang.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              LocaleKeys.changeLangYouWant.tr(),
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            _LanguageOption(
              image: AppImages.arabicImage,
              label: !context.isArabic ? "Arabic " : "اللغة العربية",
              selected: current == 'ar',
              onTap: () => _pick(context, const Locale('ar', '')),
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              image: AppImages.englishImage,
              label: context.isArabic ? "English " : "اللغة الانجليزية",
              selected: current == 'en',
              onTap: () => _pick(context, const Locale('en', '')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.image,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String image;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mainColor.withValues(alpha: selected ? 0.15 : 0.3),
          border: Border.all(
            color: selected ? AppColors.mainColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.mainColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Kept for backward compatibility — used to be a full page, now just
/// renders the bottom sheet content inside a Scaffold.
class ChangeLangView extends StatelessWidget {
  const ChangeLangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.changeLang.tr())),
      body: const ChangeLangSheet(),
    );
  }
}
