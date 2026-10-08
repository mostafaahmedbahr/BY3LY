import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/PaymentBalance/data/models/wallet_history_model.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_cubit.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_states.dart';
import 'package:by3ly/features/packages/data/models/packages_model.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_cubit.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../lang/locale_keys.dart';
import '../../../../addBalance/presentation/views/add_balance_view.dart';

class PaymentAndBalanceViewBody extends StatelessWidget {
  const PaymentAndBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.mainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.tr(LocaleKeys.balance),style: AppStyles.textStyle14W500White,),
                    IconButton(onPressed: (){},
                        icon: const Icon(Icons.refresh,
                        color: AppColors.yellowColor,)
                    ),
                  ],
                ),
                BlocBuilder<ProfileCubit, ProfileStates>(
                  builder: (context, state) {
                    final balance = context
                        .read<ProfileCubit>()
                        .profileModel
                        ?.data
                        ?.user
                        ?.walletBalance;
                    final text = balance == null
                        ? '...'
                        : '${balance == balance.roundToDouble() ? balance.toInt() : balance} ج.م';
                    return Text(
                      text,
                      style:
                          AppStyles.textStyle14W500White.copyWith(
                        fontSize: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<PackagesCubit, PackagesStates>(
            builder: (context, state) {
              final packages =
                  PackagesCubit.get(context).allPackages;
              Packages? current;
              for (final p in packages) {
                if (p.isSubscriped == true) {
                  current = p;
                  break;
                }
              }
              if (current == null) {
                return const SizedBox.shrink();
              }
              final pkg = current;
              var endsAt = (pkg.endsAt ?? '').trim();
              if (endsAt.length > 10) {
                endsAt = endsAt.substring(0, 10);
              }
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.mainColor
                          .withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.card_membership_rounded,
                          size: 18,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الباقة الحالية: ${pkg.name ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'ينتهي في: ${endsAt.isNotEmpty ? endsAt : '...'}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xff9AA0A6),
                            ),
                          ),
                        ),
                        Text(
                          pkg.remainingAds != null
                              ? 'المتبقي: ${pkg.remainingAds} إعلان'
                              : '',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(context.tr(LocaleKeys.previousActivities),style: AppStyles.textStyle16W500Black,),
          ),
          Expanded(
            child: BlocBuilder<WalletCubit, WalletStates>(
              builder: (context, state) {
                final cubit = WalletCubit.get(context);
                if (state is GetWalletHistoryLoadingState) {
                  return const CustomLoading();
                }
                if (state is GetWalletHistoryErrorState) {
                  return CustomErrorWidget(
                    error: state.error,
                    onTap: () => cubit.getHistory(),
                  );
                }
                final history = cubit.history;
                if (history.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا يوجد عمليات سابقة",
                      style: TextStyle(color: Color(0xff9AA0A6)),
                    ),
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return _HistoryItem(item: history[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const CustomSizedBox(height: 16);
                  },
                  itemCount: history.length,
                );
              },
            ),
          ),
          const CustomSizedBox(height: 20,),
          CustomButton(
            btnText: Text(context.tr(LocaleKeys.addCredit),
              style: AppStyles.textStyle16W600Black.copyWith(
                color: AppColors.whiteColor,
              ),),
            onPressed: (){
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const AddBalanceView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.item});

  final WalletHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final credit = item.isCredit;
    final amount = item.amount;
    final amountText = amount == null
        ? '...'
        : '${amount == amount.roundToDouble() ? amount.toInt() : amount} ج.م';
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: (credit ? AppColors.mainColor : AppColors.redColor)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              credit ? Icons.add : Icons.remove,
              color: credit ? AppColors.mainColor : AppColors.redColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.typeLabel?.trim().isNotEmpty ?? false)
                      ? item.typeLabel!
                      : (credit ? 'إيداع' : 'خصم'),
                  style: AppStyles.textStyle14W500White.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
                if (item.dateLabel.isNotEmpty)
                  Text(
                    item.dateLabel,
                    style: AppStyles.textStyle10W400Gray,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${credit ? '+' : '-'} $amountText',
                style: AppStyles.textStyle16W500Black.copyWith(
                  color: credit
                      ? AppColors.mainColor
                      : AppColors.redColor,
                ),
              ),
              if ((item.statusLabel?.trim().isNotEmpty ?? false))
                Text(
                  item.statusLabel!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff9AA0A6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
