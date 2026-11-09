import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Premium gradient hero shown at the top of the ad form.
///
/// Shows a live completion percentage derived from the real form state
/// (images, name, description, price, category(+sub), city+center) so the
/// header never lies about the form's progress.
class PremiumHeroHeader extends StatelessWidget {
  const PremiumHeroHeader({super.key});

  static const int _totalSteps = 6;

  int _completedSteps(AddNewAdCubit c) {
    var done = 0;
    if (c.totalImagesCount >= 1) done++;
    if (c.nameCon.text.trim().isNotEmpty) done++;
    if (c.descCon.text.trim().isNotEmpty) done++;
    final price = double.tryParse(c.priceCon.text.trim());
    if (price != null && price > 0) done++;
    if (c.categoryId != null && c.subCategoryId != null) done++;
    if (c.cityId != null && c.centerId != null) done++;
    return done;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AddNewAdCubit.get(context);
    final done = _completedSteps(cubit);
    final pct = done / _totalSteps;
    return Semantics(
      label:
          '${context.tr(LocaleKeys.premiumFormProgress)} ${(pct * 100).round()}%',
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.mainColor,
              AppColors.secondColor,
              Color(0xff0D4B74),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative rings — pure ornament, non-interactive.
            PositionedDirectional(
              top: -30,
              start: -30,
              child: _Ring(size: 110, opacity: 0.10),
            ),
            PositionedDirectional(
              top: 24,
              end: -34,
              child: _Ring(size: 88, opacity: 0.10),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: AppColors.yellowColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr(LocaleKeys.addNewAd),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.tr(LocaleKeys.premiumFormTagline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr(LocaleKeys.premiumFormProgress),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(pct * 100).round()}%  •  $done/$_totalSteps',
                        style: const TextStyle(
                          color: AppColors.yellowColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 7,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.22),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.yellowColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft decorative circle outline.
class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.opacity});

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
          width: 22,
        ),
      ),
    );
  }
}
