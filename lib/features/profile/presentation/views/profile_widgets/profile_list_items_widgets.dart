import 'package:by3ly/features/compare/presentation/views/compare_view.dart';
import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../main_importants.dart';
import '../../../../fav/presentation/views/fav_view.dart';
import '../../../../statistics/presentation/views/statistics_view.dart';

/// روابط سريعة في صف واحد مدمج (بدل 5 عناصر مرصوصة بطول 65 لكل عنصر).
class ProfileListItemsWidgets extends StatelessWidget {
  const ProfileListItemsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
      child: Row(
        children: [
          _QuickAction(
            icon: CupertinoIcons.money_pound_circle,
            label: context.tr(LocaleKeys.paymentAndBalance),
            onTap: () => _push(context, const PaymentAndBalanceView()),
          ),
          _QuickAction(
            icon: CupertinoIcons.heart_fill,
            label: LocaleKeys.favorite.tr(),
            onTap: () => _push(context, const FavView()),
          ),
          _QuickAction(
            icon: CupertinoIcons.chart_bar_fill,
            label: LocaleKeys.statistics.tr(),
            onTap: () => _push(context, const StatisticsView()),
          ),
          _QuickAction(
            icon: CupertinoIcons.square_split_2x2_fill,
            label: LocaleKeys.comparison.tr(),
            onTap: () => _push(context, const CompareView()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: page),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 21, color: AppColors.mainColor),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 24,
                  child: Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textStyle14W500Black.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
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
