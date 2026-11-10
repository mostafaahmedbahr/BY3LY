import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium animated page indicator — pills that stretch and fade for the
/// active page.
class OnBoardingIndicator extends StatelessWidget {
  const OnBoardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            height: 7,
            width: currentIndex == i ? 28 : 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentIndex == i
                  ? AppColors.yellowColor
                  : Colors.white.withValues(alpha: 0.30),
            ),
          ),
          if (i != count - 1) const SizedBox(width: 7),
        ],
      ],
    );
  }
}
