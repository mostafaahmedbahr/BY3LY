import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_cubit.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../packages/presentation/views/transfer_view.dart';
import '../../../../packages/presentation/view_model/packages_cubit.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';
import 'wallet_balance_card.dart';
import 'wallet_current_package_card.dart';
import 'wallet_history_list.dart';
import 'wallet_shimmer.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import '../../../../packages/data/repos/packages_repos_imple.dart';

class PaymentAndBalanceViewBody extends StatefulWidget {
  const PaymentAndBalanceViewBody({super.key});

  @override
  State<PaymentAndBalanceViewBody> createState() =>
      _PaymentAndBalanceViewBodyState();
}

class _PaymentAndBalanceViewBodyState
    extends State<PaymentAndBalanceViewBody> {
  @override
  void initState() {
    super.initState();
    // The history is loaded by the WalletCubit provider. Refresh the
    // balance too on every entry so an approved top-up shows up.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().getProfile();
    });
  }

  /// Refreshes both the balance card (profile) and the history list.
  Future<void> _refresh() async {
    await Future.wait([
      context.read<ProfileCubit>().getProfile(),
      context.read<WalletCubit>().getHistory(),
    ]);
  }

  Future<void> _addCredit() async {
    // Pushed routes can't see this page's local providers,
    // so both cubits are passed explicitly with the new route.
    final added = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: WalletCubit.get(context)),
            BlocProvider(
              create: (_) =>
                  PackagesCubit(getIt.get<PackagesRepoImpl>()),
            ),
          ],
          child: const TransferView(topUpMode: true),
        ),
      ),
    );
    if (added == true && mounted) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: AppColors.mainColor,
              onRefresh: _refresh,
              child: BlocBuilder<WalletCubit, WalletStates>(
                builder: (context, state) {
                  final cubit = WalletCubit.get(context);
                  final loading = state is GetWalletHistoryLoadingState ||
                      state is WalletInitState;
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    children: [
                      if (loading)
                        const WalletPageShimmer()
                      else ...[
                        WalletBalanceCard(onRefresh: _refresh),
                        const SizedBox(height: 12),
                        const WalletCurrentPackageCard(),
                        const SizedBox(height: 18),
                        Text(
                          context.tr(LocaleKeys.previousActivities),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.1,
                          ).copyWith(color: AppColors.text),
                        ),
                        const SizedBox(height: 10),
                        if (state is GetWalletHistoryErrorState)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: CustomErrorWidget(
                              error: state.error,
                              onTap: () => cubit.getHistory(),
                            ),
                          )
                        else
                          WalletHistoryList(items: cubit.history),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          // Premium pinned CTA — same height/radius DNA everywhere.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.mainColor, AppColors.secondColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor
                            .withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _addCredit,
                      borderRadius: BorderRadius.circular(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.tr(LocaleKeys.addCredit),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
