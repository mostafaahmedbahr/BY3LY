import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view_model/on_boarding_config.dart';
import 'widgets/onboarding_indicator.dart';
import 'widgets/onboarding_slide.dart';

/// Premium onboarding experience: full-brand gradient backdrop with soft
/// glows, one animated illustration card per slide, a white-bold title,
/// animated pill indicator and a gold CTA that becomes "ابدأ الآن" on the
/// last page.
class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final List<OnBoardingConfig> _slides = onBoardingSlides();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLast => _currentIndex == _slides.length - 1;

  void _next() {
    if (_isLast) {
      HapticFeedback.mediumImpact();
      context.pushNamedAndRemoveAll(Routes.loginView);
    } else {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skip() {
    HapticFeedback.lightImpact();
    context.pushNamedAndRemoveAll(Routes.loginView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMainColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.darkMainColor,
              AppColors.mainColor,
              AppColors.secondColor,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top brand bar + skip.
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.yellowColor.withValues(alpha: 0.9),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.yellowColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'بيعلي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Spacer(),
                    if (!_isLast)
                      InkWell(
                        onTap: _skip,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            context.tr(LocaleKeys.skip),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Illustration pager.
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) =>
                      OnBoardingSlide(slide: _slides[index], page: index),
                ),
              ),
              // Bottom indicator + CTA.
              OnBoardingIndicator(
                count: _slides.length,
                currentIndex: _currentIndex,
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.yellowColor, Color(0xffE08B1B)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellowColor.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _next,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isLast
                                    ? context.tr(LocaleKeys.getStarted)
                                    : context.tr(LocaleKeys.next),
                                style: const TextStyle(
                                  color: Color(0xff1A1205),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _isLast
                                    ? Icons.arrow_outward_rounded
                                    : Icons.arrow_forward_rounded,
                                color: const Color(0xff1A1205),
                                size: 19,
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
        ),
      ),
    );
  }
}
