import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../../view_model/on_boarding_config.dart';

/// One onboarding slide: illustration in a softly-glowing white card,
/// title + body beneath on the dark gradient backdrop.
///
/// The illustration card scales with the available height instead of a
/// fixed fraction of width so the layout never overflows on shorter screens.
class OnBoardingSlide extends StatelessWidget {
  const OnBoardingSlide({super.key, required this.slide, required this.page});

  final OnBoardingConfig slide;
  final int page;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Illustration area fills the remaining vertical space.
          Expanded(
            child: Center(
              child: SizedBox(
                width: size.width * 0.78,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow halo behind the card.
                    Container(
                      width: size.width * 0.68,
                      height: size.width * 0.68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.yellowColor.withValues(alpha: 0.30),
                            AppColors.yellowColor.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                    // White card holding the illustration.
                    Container(
                      width: size.width * 0.78,
                      height: size.height * 0.30,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        slide.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Copy block on the dark backdrop.
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 14, 30, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slide.title(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.body(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: 13.5,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
