import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/product_seller_cubit.dart';
import '../../view_model/product_seller_states.dart';

/// Premium segmented tabs — three pills (Profile / Live / Sold).
class SellerTabButtons extends StatelessWidget {
  const SellerTabButtons({super.key});

  static const _tabs = [
    (1, LocaleKeys.sellerDataTab),
    (2, LocaleKeys.currentLiveAds),
    (3, LocaleKeys.previousSales),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSellerCubit, ProductSellerStates>(
      builder: (context, state) {
        final cubit = ProductSellerCubit.get(context);
        final active = cubit.sellerDataIndex;

        return Row(
          children: [
            for (int i = 0; i < _tabs.length; i++) ...[
              Expanded(
                child: InkWell(
                  onTap: () => cubit.changeSellerDataIndex(_tabs[i].$1),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    height: 44,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: active == _tabs[i].$1
                          ? AppColors.mainColor
                          : AppColors.surface,
                      border: Border.all(
                        color: active == _tabs[i].$1
                            ? AppColors.mainColor
                            : AppColors.border,
                        width: 1.1,
                      ),
                      boxShadow: active == _tabs[i].$1
                          ? [
                              BoxShadow(
                                color: AppColors.mainColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      context.tr(_tabs[i].$2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active == _tabs[i].$1
                            ? Colors.white
                            : AppColors.text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              if (i != _tabs.length - 1) const SizedBox(width: 8),
            ],
          ],
        );
      },
    );
  }
}
