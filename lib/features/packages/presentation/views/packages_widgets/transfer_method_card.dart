import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/new_toast/toast.dart';
import '../../../data/models/payment_methods_model.dart';
import 'brand_logo.dart';

/// Brand identity per payment method (matched by code/name).
class PaymentMethodBrand {
  const PaymentMethodBrand(this.color, this.icon,
      [this.kind = BrandLogoKind.generic]);
  final Color color;
  final IconData icon;
  final BrandLogoKind kind;
}

PaymentMethodBrand brandForPaymentMethod(PaymentMethod method) {
  final text =
      '${method.code ?? ''} ${method.name ?? ''}'.toLowerCase();
  if (text.contains('vodafone') || text.contains('فودافون')) {
    return const PaymentMethodBrand(
      Color(0xffE60000),
      Icons.smartphone_rounded,
      BrandLogoKind.vodafone,
    );
  }
  if (text.contains('orange') ||
      text.contains('اورنج') ||
      text.contains('أورانج')) {
    return const PaymentMethodBrand(
        Color(0xffFF7900), Icons.smartphone_rounded);
  }
  if (text.contains('etisalat') ||
      text.contains('اتصالات') ||
      text.contains('e&') ||
      text.contains('إي_اند')) {
    return const PaymentMethodBrand(
      Colors.black,
      Icons.smartphone_rounded,
      BrandLogoKind.etisalat,
    );
  }
  if (text.contains('instapay') ||
      text.contains('انستا') ||
      text.contains('insta_pay')) {
    return const PaymentMethodBrand(
      Color(0xff5B2C86),
      Icons.bolt_rounded,
      BrandLogoKind.instapay,
    );
  }
  if (text.contains('fawry') || text.contains('فوري')) {
    return const PaymentMethodBrand(
        Color(0xffB8860B), Icons.storefront_rounded);
  }
  if (text.contains('bank') ||
      text.contains('بنك') ||
      text.contains('iban') ||
      text.contains('حساب بنكي')) {
    return const PaymentMethodBrand(
        Color(0xff1B3A6B), Icons.account_balance_rounded);
  }
  if (text.contains('wallet') || text.contains('محفظ')) {
    return const PaymentMethodBrand(
        AppColors.mainColor, Icons.account_balance_wallet_rounded);
  }
  if (text.contains('cash') || text.contains('كاش')) {
    return const PaymentMethodBrand(
        Color(0xff2E7D32), Icons.payments_rounded);
  }
  return const PaymentMethodBrand(
      AppColors.mainColor, Icons.swap_horiz_rounded);
}

/// Selectable payment-method card with the official company logo,
/// account number chip and copy button — the same card everywhere
/// (package transfer page and add-ad payment sheet).
class TransferMethodCard extends StatelessWidget {
  const TransferMethodCard({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final brand = brandForPaymentMethod(method);
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: selected ? brand.color : const Color(0xffE3E6E9),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Official company logo.
            Stack(
              clipBehavior: Clip.none,
              children: [
                BrandLogo(
                  kind: brand.kind,
                  fallbackIcon: brand.icon,
                  fallbackColor: brand.color,
                ),
                if (selected)
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: brand.color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: brand.color,
                    ),
                  ),
                  if ((method.account?.trim().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F3F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        method.account!,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: brand.color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if ((method.account?.trim().isNotEmpty ?? false))
              IconButton(
                tooltip: 'نسخ',
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: method.account!),
                  );
                  Toast.showSuccessToast(
                    msg: 'تم نسخ الرقم',
                    context: context,
                  );
                },
                icon: Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: brand.color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
