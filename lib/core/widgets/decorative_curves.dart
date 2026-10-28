import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A filled band between two quadratic curves. All points are fractions of
/// the canvas (x of width, y of height).
class CurveBand {
  const CurveBand({
    required this.outer,
    required this.inner,
    required this.colors,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  /// start, control, end
  final List<Offset> outer;
  final List<Offset> inner;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
}

class DecorativeCurves extends StatelessWidget {
  const DecorativeCurves({super.key, required this.bands});

  final List<CurveBand> bands;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: _CurvesPainter(bands)),
    );
  }
}

class _CurvesPainter extends CustomPainter {
  _CurvesPainter(this.bands);

  final List<CurveBand> bands;

  @override
  void paint(Canvas canvas, Size size) {
    Offset p(Offset f) => Offset(f.dx * size.width, f.dy * size.height);

    for (final band in bands) {
      final o = band.outer.map(p).toList();
      final i = band.inner.map(p).toList();
      final path = Path()
        ..moveTo(o[0].dx, o[0].dy)
        ..quadraticBezierTo(o[1].dx, o[1].dy, o[2].dx, o[2].dy)
        ..lineTo(i[2].dx, i[2].dy)
        ..quadraticBezierTo(i[1].dx, i[1].dy, i[0].dx, i[0].dy)
        ..close();

      final bounds = path.getBounds();
      final paint = Paint()..isAntiAlias = true;
      if (band.colors.length == 1) {
        paint.color = band.colors.first;
      } else {
        paint.shader = LinearGradient(
          begin: band.begin,
          end: band.end,
          colors: band.colors,
        ).createShader(bounds);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CurvesPainter old) => old.bands != bands;
}

/// Swooshes used on the splash screen: red in the top-left corner,
/// navy / blue / gold sweeping across the bottom.
const splashCurveBands = <CurveBand>[
  // top-left
  CurveBand(
    outer: [Offset(0, 0.040), Offset(0.09, 0.026), Offset(0.15, 0)],
    inner: [Offset(0, 0.033), Offset(0.075, 0.021), Offset(0.125, 0)],
    colors: [AppColors.curveRed, AppColors.red],
  ),
  CurveBand(
    outer: [Offset(0, 0.098), Offset(0.21, 0.064), Offset(0.37, 0)],
    inner: [Offset(0, 0.060), Offset(0.135, 0.039), Offset(0.24, 0)],
    colors: [
      AppColors.curveRedDark,
      AppColors.curveRed,
      AppColors.redHighlight,
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  ),
  CurveBand(
    outer: [Offset(0, 0.113), Offset(0.25, 0.074), Offset(0.44, 0)],
    inner: [Offset(0, 0.104), Offset(0.23, 0.068), Offset(0.40, 0)],
    colors: [AppColors.paleRose, Color(0xFFFBEDEC)],
  ),

  // bottom-left
  CurveBand(
    outer: [Offset(0, 0.880), Offset(0.22, 0.975), Offset(0.52, 1)],
    inner: [Offset(0, 0.905), Offset(0.18, 0.982), Offset(0.40, 1)],
    colors: [AppColors.lightGrey, AppColors.silverWhite],
  ),
  CurveBand(
    outer: [Offset(0, 0.945), Offset(0.10, 0.99), Offset(0.24, 1)],
    inner: [Offset(0, 0.958), Offset(0.07, 0.993), Offset(0.17, 1)],
    colors: [Color(0xFF12528B), Color(0xFF0A315E)],
  ),

  // bottom-right
  CurveBand(
    outer: [Offset(1, 0.775), Offset(0.62, 0.93), Offset(0.02, 1)],
    inner: [Offset(1, 0.805), Offset(0.66, 0.945), Offset(0.16, 1)],
    colors: [Color(0x00DCEAFB), AppColors.paleBlue],
  ),
  CurveBand(
    outer: [Offset(1, 0.825), Offset(0.70, 0.955), Offset(0.22, 1)],
    inner: [Offset(1, 0.872), Offset(0.76, 0.97), Offset(0.40, 1)],
    colors: [AppColors.curveBlue, AppColors.curveNavy],
  ),
  CurveBand(
    outer: [Offset(1, 0.884), Offset(0.80, 0.975), Offset(0.46, 1)],
    inner: [Offset(1, 0.902), Offset(0.83, 0.98), Offset(0.56, 1)],
    colors: [AppColors.curveGoldLight, AppColors.curveGold],
  ),
  CurveBand(
    outer: [Offset(1, 0.912), Offset(0.86, 0.985), Offset(0.62, 1)],
    inner: [Offset(1, 0.94), Offset(0.90, 0.99), Offset(0.76, 1)],
    colors: [AppColors.curveNavy, Color(0xFF0A315E)],
  ),
];
