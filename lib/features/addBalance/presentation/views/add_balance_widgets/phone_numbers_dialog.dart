import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_config.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dialog listing the support numbers the customer can call or type.
/// Replaceable with a server-driven list when the API provides it.
class PhoneNumbersDialog extends StatelessWidget {
  const PhoneNumbersDialog({super.key});

  /// Shows the dialog. Dismissible from the barrier and from the close icon.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const PhoneNumbersDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(LocaleKeys.numbersConversionInfo),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.tr(LocaleKeys.back),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: AddBalanceConfig.supportPhoneNumbers
                      .map((number) => _SupportNumberTile(number: number))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.tr(LocaleKeys.back)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One support number with copy + call actions.
class _SupportNumberTile extends StatelessWidget {
  const _SupportNumberTile({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.border.withValues(alpha: 0.6),
        ),
      ),
      color: AppColors.surfaceVariant,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          number,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.text,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'نسخ',
              icon: const Icon(Icons.copy_rounded),
              color: AppColors.mainColor,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: number));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(context.tr(LocaleKeys.numberCopied)),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'اتصال',
              icon: const Icon(Icons.phone_rounded),
              color: AppColors.mainColor,
              onPressed: () =>
                  BlocProvider.of<AddBalanceCubit>(context)
                      .makePhoneCall(number, context),
            ),
          ],
        ),
      ),
    );
  }
}
