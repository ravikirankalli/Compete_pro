import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// "From / Andhra Educational Trust" signature flanked by gold rules.
class TrustAttribution extends StatelessWidget {
  const TrustAttribution({
    super.key,
    this.scale = 1,
    this.textColor = AppColors.institution,
    this.lineColor = AppColors.institutionGold,
  });

  final double scale;
  final Color textColor;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    final rule = Container(width: 30 * scale, height: 1.2, color: lineColor);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'From',
          style: TextStyle(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w400,
            fontSize: 12.5 * scale,
            color: textColor,
          ),
        ),
        SizedBox(height: 4 * scale),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            rule,
            SizedBox(width: 12 * scale),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Andhra Educational Trust',
                  style: TextStyle(
                    fontFamily: AppFonts.serif,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5 * scale,
                    color: textColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12 * scale),
            rule,
          ],
        ),
      ],
    );
  }
}
