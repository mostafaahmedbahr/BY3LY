import 'dart:ui';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Full-width gradient call-to-action with a soft glow and a slow
/// light sweep. Used for both "next step" and the final publish/edit
/// action, driven by explicit [label] and [icon].
class PremiumCtaButton extends StatelessWidget {
  const PremiumCtaButton({
    super.key,
    required this.submitting,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final bool submitting;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.mainColor,
              AppColors.secondColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: submitting ? null : onPressed,
            child: submitting
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      // Slow glass highlight sweep.
                      const _LightSweep(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(icon, color: Colors.white, size: 20),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Diagonal translucent band that sweeps once every few seconds.
class _LightSweep extends StatefulWidget {
  const _LightSweep();

  @override
  State<_LightSweep> createState() => _LightSweepState();
}

class _LightSweepState extends State<_LightSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(period: const Duration(milliseconds: 3400));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ).value;
        // Sweep from -1.6 to 1.6 (off-screen to off-screen).
        final dx = lerpDouble(-1.6, 1.6, t)!;
        return Transform.translate(
          offset: Offset(dx * 160, 0),
          child: Transform.rotate(
            angle: 0.35,
            child: Container(
              width: 60,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        );
      },
    );
  }
}
