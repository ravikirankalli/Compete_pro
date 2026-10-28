import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// White card with the brand blue-to-red gradient border, soft shadow and
/// ink ripple.
class TileFrame extends StatelessWidget {
  const TileFrame({
    super.key,
    required this.onTap,
    required this.child,
    this.radius = 16,
  });

  final VoidCallback onTap;
  final Widget child;
  final double radius;

  static const _borderWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final inner = BorderRadius.circular(radius - _borderWidth);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.brandGradient.colors,
          stops: AppColors.brandGradient.stops,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x290A1B3A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(_borderWidth),
        child: Material(
          color: Colors.transparent,
          borderRadius: inner,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: inner,
              border: Border.all(color: Colors.white, width: 2),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEFF3F9), AppColors.white, Color(0xFFF7F8FB)],
                stops: [0, 0.45, 1],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: AppColors.buttonEnd.withValues(alpha: 0.10),
              highlightColor: AppColors.buttonStart.withValues(alpha: 0.05),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
