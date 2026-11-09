import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

/// Premium language picker shown as a full bottom sheet.
///
/// Structure:
///   * gradient hero with a frosted globe badge (same family as the ad
///     publish hero on the app), followed by
///   * two flag-rich option cards (selected card gets a gold check), and
///   * a proof-line hint at the bottom ("Applies instantly").
Future<void> showChangeLangSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const ChangeLangSheet(),
  );
}

/// Re-fetches all the app's initial data after a language change,
/// so every screen shows data in the new language.
/// Each call is isolated so one failing cubit doesn't block the rest.
void refreshAllData(BuildContext context) {
  final isGuest = GuestGuard.isGuest;

  // Home (always).
  _safeRefresh(context, 'HomeCubit.getHome',
      () => context.read<HomeCubit>().getHome());
  _safeRefresh(context, 'HomeCubit.getBanners',
      () => context.read<HomeCubit>().getBanners());

  // Shared lists (always).
  _safeRefresh(context, 'SearchCubit.getAllProductsForSearch',
      () => context.read<SearchCubit>().getAllProductsForSearch());
  _safeRefresh(context, 'ChooseLocationCubit.getAllCitiesAndCenters',
      () => context.read<ChooseLocationCubit>().getAllCitiesAndCenters());
  _safeRefresh(context, 'ReportProductCubit.getAllComplaintsTypesData',
      () => context.read<ReportProductCubit>().getAllComplaintsTypesData());
  _safeRefresh(context, 'SellAllBestViewCubit.getSellAllBestView',
      () => context.read<SellAllBestViewCubit>().getSellAllBestView());

  // Account-scoped data (skip for guests to avoid 401s).
  if (!isGuest) {
    _safeRefresh(context, 'ProfileCubit.getProfile',
        () => context.read<ProfileCubit>().getProfile());
    _safeRefresh(context, 'PrivacyCubit.getSettings',
        () => context.read<PrivacyCubit>().getSettings());
    _safeRefresh(context, 'FavCubit.getFavData',
        () => context.read<FavCubit>().getFavData());
    _safeRefresh(context, 'NotificationsCubit.refresh',
        () => context.read<NotificationsCubit>().refresh());
    _safeRefresh(context, 'ChatUnreadCubit.refresh',
        () => context.read<ChatUnreadCubit>().refresh());
  }
}

void _safeRefresh(BuildContext context, String label, VoidCallback action) {
  try {
    action();
  } catch (e, s) {
    debugPrint('refreshAllData: $label failed: $e\n$s');
  }
}

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
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          child: ColoredBox(
            color: AppColors.surface,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Branded hero ───────────────────────────────
                  _LanguageSheetHero(
                    title: context.tr(LocaleKeys.changeLang),
                    subtitle: context.tr(LocaleKeys.changeLangYouWant),
                    onClose: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _LanguageOption(
                      image: AppImages.arabicImage,
                      title: 'العربية',
                      subtitle: 'RTL · لغة الأم للتطبيق',
                      selected: current == 'ar',
                      accent: const Color(0xff0E8565),
                      onTap: () => _pick(context, const Locale('ar', '')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _LanguageOption(
                      image: AppImages.englishImage,
                      title: 'English',
                      subtitle: 'LTR · Default for international users',
                      selected: current == 'en',
                      accent: const Color(0xff0D4B74),
                      onTap: () => _pick(context, const Locale('en', '')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ── Proof / confidence row ─────────────────────
                  _SheetHint(text: context.tr(LocaleKeys.changeLangYouWant)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Branded gradient hero with a frosted globe badge.
class _LanguageSheetHero extends StatelessWidget {
  const _LanguageSheetHero({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Soft decorative rings
              Positioned(
                top: -34,
                left: -36,
                child: _GlowCircle(size: 140, opacity: 0.09),
              ),
              Positioned(
                bottom: -42,
                right: -44,
                child: _GlowCircle(size: 170, opacity: 0.08),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _GlobeBadge(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11.5,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close X
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: onClose,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Soft fade at the bottom into the content background
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.surface,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlobeBadge extends StatelessWidget {
  const _GlobeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffFAB043),
            Color(0xffE8890C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFAB043).withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.language_rounded, color: Colors.white, size: 28),
          // Subtle inner highlight
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 28,
        ),
      ),
    );
  }
}

/// Flag-rich language option with premium check & shadow treatment.
class _LanguageOption extends StatefulWidget {
  const _LanguageOption({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_LanguageOption> createState() => _LanguageOptionState();
}

class _LanguageOptionState extends State<_LanguageOption>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  @override
  void initState() {
    super.initState();
    _checkCtl.value = widget.selected ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant _LanguageOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _checkCtl.forward();
      } else {
        _checkCtl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _checkCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return Semantics(
      button: true,
      selected: selected,
      label: '${widget.title} · ${selected ? 'محدد' : 'متاح'}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.mainColor.withValues(alpha: 0.12),
          highlightColor: AppColors.mainColor.withValues(alpha: 0.06),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected
                  ? widget.accent.withValues(alpha: 0.08)
                  : AppColors.surface,
              border: Border.all(
                color: selected
                    ? widget.accent
                    : AppColors.border.withValues(alpha: 0.6),
                width: selected ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? widget.accent.withValues(alpha: 0.22)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: selected ? 18 : 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag frame
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(widget.image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Gold check badge
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _checkCtl,
                    curve: Curves.easeOutBack,
                  ),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? const Color(0xffFAB043)
                          : AppColors.surfaceVariant,
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(0xffFAB043)
                                    .withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      selected ? Icons.check_rounded : Icons.circle_outlined,
                      color: selected ? Colors.white : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline proof hint shown under the option cards.
class _SheetHint extends StatelessWidget {
  const _SheetHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
