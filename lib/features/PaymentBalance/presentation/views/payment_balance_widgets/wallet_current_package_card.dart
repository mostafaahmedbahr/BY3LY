import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../packages/data/models/packages_model.dart';
import '../../../../packages/presentation/view_model/packages_cubit.dart';
import '../../../../packages/presentation/view_model/packages_states.dart';

/// Premium card showing the user's currently subscribed package
/// (name + end date + remaining ads). Renders nothing when unsubscribed.
class WalletCurrentPackageCard extends StatelessWidget {
  const WalletCurrentPackageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesCubit, PackagesStates>(
      builder: (context, state) {
        final packages = PackagesCubit.get(context).allPackages;
        Packages? current;
        for (final p in packages) {
          if (p.isSubscriped == true) {
            current = p;
            break;
          }
        }
        if (current == null) return const SizedBox.shrink();
        final pkg = current;

        var endsAt = (pkg.endsAt ?? '').trim();
        if (endsAt.length > 10) endsAt = endsAt.substring(0, 10);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.yellowColor.withValues(alpha: 0.55),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.yellowColor.withValues(alpha: 0.10),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.yellowColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.yellowColor.withValues(alpha: 0.7),
                    width: 1.3,
                  ),
                ),
                child: const Icon(
                  Icons.card_membership_rounded,
                  color: AppColors.yellowColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(LocaleKeys.currentPackageLabel),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pkg.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ).copyWith(color: AppColors.text),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${context.tr(LocaleKeys.expiresOn)}: ${endsAt.isNotEmpty ? endsAt : '...'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (pkg.remainingAds != null)
                          Text(
                            '${pkg.remainingAds} ${context.tr(LocaleKeys.adsCount)}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
