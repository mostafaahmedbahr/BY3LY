import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../../profile/presentation/view_model/profile_states.dart';

/// Premium gradient wallet balance card with a refresh action.
class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkMainColor,
            AppColors.mainColor,
            AppColors.secondColor,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr(LocaleKeys.balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onRefresh,
                tooltip: context.tr(LocaleKeys.balance),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.yellowColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              final balance = context
                  .read<ProfileCubit>()
                  .profileModel
                  ?.data
                  ?.user
                  ?.walletBalance;
              if (balance == null) {
                return const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: SimmerLoading(
                    height: 30,
                    width: 130,
                    raduis: 8,
                  ),
                );
              }
              final wholeNumber = balance == balance.roundToDouble();
              final text = wholeNumber
                  ? balance.toInt().toString()
                  : balance.toString();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'ج.م',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
