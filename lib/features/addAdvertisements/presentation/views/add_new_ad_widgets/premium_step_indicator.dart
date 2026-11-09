import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Premium horizontal stepper for the add/edit ad wizard:
/// gradient dots with icons, animated connector fill, and short labels.
class PremiumStepIndicator extends StatelessWidget {
  const PremiumStepIndicator({super.key, required this.currentStep});

  final int currentStep;

  static const List<IconData> _icons = [
    Icons.category_rounded,
    Icons.article_rounded,
    Icons.payments_rounded,
    Icons.photo_library_rounded,
    Icons.local_shipping_rounded,
    Icons.location_on_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.tr(LocaleKeys.category),
      context.tr(LocaleKeys.adName),
      context.tr(LocaleKeys.priceAndOffer),
      context.tr(LocaleKeys.selectImages),
      context.tr(LocaleKeys.shippingType),
      context.tr(LocaleKeys.place),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_icons.length, (i) {
          final isLast = i == _icons.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(child: _StepDot(
                  index: i,
                  currentStep: currentStep,
                  icon: _icons[i],
                  label: labels[i],
                )),
                if (!isLast)
                  _Connector(filled: i < currentStep),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// One step dot + label. Done → gradient with check; current → gradient
/// with glow; upcoming → quiet tinted circle.
class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.currentStep,
    required this.icon,
    required this.label,
  });

  final int index;
  final int currentStep;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final done = index < currentStep;
    final current = index == currentStep;
    final highlighted = done || current;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: highlighted
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.mainColor,
                      AppColors.secondColor,
                    ],
                  )
                : null,
            color: highlighted ? null : AppColors.surfaceVariant,
            border: Border.all(
              color: highlighted
                  ? Colors.transparent
                  : AppColors.border.withValues(alpha: 0.8),
            ),
            boxShadow: current
                ? [
                    BoxShadow(
                      color: AppColors.mainColor
                          .withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: 1.5,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Icon(
            done ? Icons.check_rounded : icon,
            size: 17,
            color:
                highlighted ? Colors.white : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 50,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5,
              height: 1.1,
              fontWeight:
                  current ? FontWeight.w800 : FontWeight.w500,
              color: current
                  ? AppColors.accent
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated connecting line; fills when the previous step is done.
class _Connector extends StatelessWidget {
  const _Connector({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Align(
        alignment: const Alignment(0, -0.25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: filled
                ? AppColors.mainColor
                : AppColors.surfaceVariant,
          ),
        ),
      ),
    );
  }
}
