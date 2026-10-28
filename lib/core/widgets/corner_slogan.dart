import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// Small, widely tracked uppercase slogan block with a short rule beneath.
class CornerSlogan extends StatelessWidget {
  const CornerSlogan({
    super.key,
    required this.lines,
    this.fontSize = 8.5,
    this.letterSpacing = 2.4,
    this.lineHeight = 1.95,
    this.color = AppColors.slogan,
  });

  final List<String> lines;
  final double fontSize;
  final double letterSpacing;
  final double lineHeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lines.join('\n'),
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            height: lineHeight,
            color: color,
          ),
        ),
        SizedBox(height: fontSize * 0.6),
        Container(width: fontSize * 2.4, height: 1.2, color: color),
      ],
    );
  }
}
