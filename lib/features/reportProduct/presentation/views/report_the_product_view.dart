import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/report_ad_view_body.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/report_the_product_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Premium report screen — brand gradient AppBar with a flag icon.
/// Two flows live here: ad report (sellerId + productId) and the general
/// support complaint (either id missing).
class ReportTheProductView extends StatelessWidget {
  const ReportTheProductView({super.key, this.sellerId, this.productId});

  final int? sellerId;
  final int? productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.flag_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.tr(LocaleKeys.reportProduct),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      body: (sellerId != null && productId != null)
          // Report a specific ad: reasons + reportAd endpoint.
          ? ReportAdViewBody(
              sellerId: sellerId!,
              productId: productId!,
            )
          // General complaint (e.g. from help & support).
          : ReportTheProductViewBody(
              sellerId: sellerId,
              productId: productId,
            ),
    );
  }
}
