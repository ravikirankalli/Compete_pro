import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// "Compete Pro" wordmark: heavy italic, navy "Compete" + red "Pro",
/// with a vertical shade to give the embossed look of the brand artwork.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.only(right: 14, bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShadedWord(
                'Compete',
                colors: [
                  AppColors.navyHighlight,
                  AppColors.navy,
                  AppColors.navyDark,
                ],
              ),
              SizedBox(width: 14),
              _ShadedWord(
                'Pro',
                colors: [
                  AppColors.redHighlight,
                  AppColors.red,
                  AppColors.redDark,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShadedWord extends StatelessWidget {
  const _ShadedWord(this.text, {required this.colors});

  final String text;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: AppFonts.montserrat,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      fontSize: 100,
      height: 1.05,
      letterSpacing: -4,
    );

    return Stack(
      children: [
        // soft drop shadow under the letters
        Transform.translate(
          offset: const Offset(2, 5),
          child: Text(
            text,
            style: style.copyWith(
              foreground: Paint()
                ..color = const Color(0x33071A38)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
            ),
          ),
        ),
        // darker extruded lower edge
        Transform.translate(
          offset: const Offset(0, 3),
          child: Text(text, style: style.copyWith(color: colors.last)),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(text, style: style.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
