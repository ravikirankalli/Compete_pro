import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Thin horizontal rules split by three slanted brand slashes
/// (used under the wordmark and under the "Login" title).
class AccentDivider extends StatelessWidget {
  const AccentDivider({
    super.key,
    required this.width,
    this.slashWidth = 18,
    this.slashHeight = 6,
    this.lineThickness = 1.4,
    this.leftLineColor = AppColors.navy,
    this.rightLineColor = const Color(0xFF2E2A55),
    this.slashColors = const [
      AppColors.slashNavy,
      AppColors.slashRed,
      AppColors.slashGold,
    ],
  });

  final double width;
  final double slashWidth;
  final double slashHeight;
  final double lineThickness;
  final Color leftLineColor;
  final Color rightLineColor;
  final List<Color> slashColors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, slashHeight),
      painter: _AccentDividerPainter(
        slashWidth: slashWidth,
        lineThickness: lineThickness,
        leftLineColor: leftLineColor,
        rightLineColor: rightLineColor,
        slashColors: slashColors,
      ),
    );
  }
}

class _AccentDividerPainter extends CustomPainter {
  _AccentDividerPainter({
    required this.slashWidth,
    required this.lineThickness,
    required this.leftLineColor,
    required this.rightLineColor,
    required this.slashColors,
  });

  final double slashWidth;
  final double lineThickness;
  final Color leftLineColor;
  final Color rightLineColor;
  final List<Color> slashColors;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final skew = h * 0.9;
    final gap = slashWidth * 0.22;
    final groupWidth =
        slashColors.length * slashWidth + (slashColors.length - 1) * gap + skew;
    final startX = (size.width - groupWidth) / 2;
    final lineGap = slashWidth * 0.6;
    final y = h / 2;

    canvas.drawLine(
      Offset(0, y),
      Offset(startX - lineGap, y),
      Paint()
        ..strokeWidth = lineThickness
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [leftLineColor.withValues(alpha: 0), leftLineColor],
          stops: const [0, 0.35],
        ).createShader(Rect.fromLTWH(0, 0, startX - lineGap, h)),
    );

    final rightStart = startX + groupWidth + lineGap;
    canvas.drawLine(
      Offset(rightStart, y),
      Offset(size.width, y),
      Paint()
        ..strokeWidth = lineThickness
        ..strokeCap = StrokeCap.round
        ..shader =
            LinearGradient(
              colors: [rightLineColor, rightLineColor.withValues(alpha: 0)],
              stops: const [0.65, 1],
            ).createShader(
              Rect.fromLTWH(rightStart, 0, size.width - rightStart, h),
            ),
    );

    for (var i = 0; i < slashColors.length; i++) {
      final x = startX + i * (slashWidth + gap);
      final path = Path()
        ..moveTo(x + skew, 0)
        ..lineTo(x + skew + slashWidth, 0)
        ..lineTo(x + slashWidth, h)
        ..lineTo(x, h)
        ..close();
      canvas.drawPath(path, Paint()..color = slashColors[i]);
    }
  }

  @override
  bool shouldRepaint(covariant _AccentDividerPainter old) =>
      old.slashWidth != slashWidth ||
      old.lineThickness != lineThickness ||
      old.leftLineColor != leftLineColor ||
      old.rightLineColor != rightLineColor ||
      old.slashColors != slashColors;
}
