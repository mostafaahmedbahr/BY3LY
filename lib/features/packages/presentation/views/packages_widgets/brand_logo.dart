import 'package:flutter/material.dart';

/// Which company mark to draw.
enum BrandLogoKind { generic, vodafone, etisalat, instapay }

/// Official company logos bundled in assets.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    required this.kind,
    this.size = 52,
    this.fallbackIcon = Icons.swap_horiz_rounded,
    this.fallbackColor = const Color(0xff0E8565),
  });

  final BrandLogoKind kind;
  final double size;
  final IconData fallbackIcon;
  final Color fallbackColor;

  String? get _asset {
    switch (kind) {
      case BrandLogoKind.vodafone:
        return "assets/images/vodafone-cash.jpg";
      case BrandLogoKind.etisalat:
        return "assets/images/etisalat-cash.png";
      case BrandLogoKind.instapay:
        return "assets/images/instapay.jpg";
      case BrandLogoKind.generic:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = _asset;
    if (asset == null) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: fallbackColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(size * 0.28),
        ),
        child: Icon(
          fallbackIcon,
          size: size * 0.5,
          color: fallbackColor,
        ),
      );
    }
    // Full-bleed image clipped to the badge shape, so dark logos
    // (like Etisalat Cash) get the same rounded edges.
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: const Color(0xffF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28 - 1),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
