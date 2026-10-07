import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../data/models/packages_model.dart';
import '../../view_model/packages_cubit.dart';
import '../../view_model/packages_states.dart';
import '../transfer_view.dart';

/// Bottom sheet shown when tapping "اشترك الآن":
/// wallet (with balance) or transfer.
Future<void> showPaymentMethodSheet(
    BuildContext context, Packages package) {
  // The sheet is a new route above the page's BlocProvider, so the
  // cubit is passed explicitly to keep it visible inside the sheet.
  final packagesCubit = PackagesCubit.get(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: packagesCubit,
      child: PaymentMethodSheet(package: package),
    ),
  );
}

class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({super.key, required this.package});

  final Packages package;

  String _formatBalance(double? value) {
    if (value == null) return '...';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final packagesCubit = PackagesCubit.get(context);
    final balance = context
        .read<ProfileCubit>()
        .profileModel
        ?.data
        ?.user
        ?.walletBalance;
    return BlocConsumer<PackagesCubit, PackagesStates>(
      listener: (context, state) {
        // Wallet checkout succeeded: close the sheet,
        // the packages page shows the toast and refreshes.
        if (state is SubscribePackageSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final paying = packagesCubit.subscribingPackageId == package.id;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffE3E6E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'اشترك في باقة ${package.name ?? ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'اختر طريقة الدفع',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff9AA0A6),
                  ),
                ),
                const SizedBox(height: 16),
                // Wallet option.
                _OptionTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'محفظة',
                  subtitle:
                      'الرصيد المتاح: ${_formatBalance(balance)} ج.م',
                  trailing: paying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.mainColor,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xffB0B5BB),
                        ),
                  onTap: paying || package.id == null
                      ? null
                      : () => packagesCubit.checkoutWithWallet(
                            packageId: package.id!,
                          ),
                ),
                const SizedBox(height: 12),
                // Transfer option.
                _OptionTile(
                  icon: Icons.swap_horiz_rounded,
                  title: 'تحويل',
                  subtitle: 'تحويل بنكي أو محافظ إلكترونية',
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xffB0B5BB),
                  ),
                  onTap: paying
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: BlocProvider.value(
                                value: packagesCubit,
                                child:
                                    TransferView(package: package),
                              ),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE3E6E9)),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9AA0A6),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
