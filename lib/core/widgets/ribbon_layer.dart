import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// A glossy ribbon following a cubic curve. Points are fractions of the
/// canvas (x of width, y of height) and should run left to right so the
/// first colour in [shades] is the upper edge.
class Ribbon {
  const Ribbon({
    required this.curve,
    required this.startWidth,
    required this.endWidth,
    required this.shades,
    this.shine = 0.45,
    this.shadow = 0.16,
  });

  /// start, control 1, control 2, end
  final List<Offset> curve;

  /// Thickness at each end, as a fraction of the canvas width.
  final double startWidth;
  final double endWidth;

  /// Colours across the ribbon, from upper edge to lower edge.
  final List<Color> shades;

  /// Opacity of the specular line near the upper edge (0 to disable).
  final double shine;

  /// Opacity of the soft drop shadow (0 to disable).
  final double shadow;
}

class RibbonLayer extends StatelessWidget {
  const RibbonLayer({super.key, required this.ribbons});

  final List<Ribbon> ribbons;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: _RibbonPainter(ribbons)),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  _RibbonPainter(this.ribbons);

  final List<Ribbon> ribbons;

  static const _samples = 72;
  static const _strips = 18;

  @override
  void paint(Canvas canvas, Size size) {
    for (final r in ribbons) {
      _paintRibbon(canvas, size, r);
    }
  }

  void _paintRibbon(Canvas canvas, Size size, Ribbon r) {
    final p = [
      for (final f in r.curve) Offset(f.dx * size.width, f.dy * size.height),
    ];
    final centers = <Offset>[];
    final normals = <Offset>[];
    final widths = <double>[];
    for (var i = 0; i <= _samples; i++) {
      final t = i / _samples;
      final u = 1 - t;
      centers.add(
        p[0] * (u * u * u) +
            p[1] * (3 * u * u * t) +
            p[2] * (3 * u * t * t) +
            p[3] * (t * t * t),
      );
      final d =
          (p[1] - p[0]) * (3 * u * u) +
          (p[2] - p[1]) * (6 * u * t) +
          (p[3] - p[2]) * (3 * t * t);
      final len = d.distance == 0 ? 1.0 : d.distance;
      normals.add(Offset(-d.dy / len, d.dx / len));
      widths.add(lerpDouble(r.startWidth, r.endWidth, t)! * size.width);
    }

    List<Offset> edge(double s) => [
      for (var i = 0; i <= _samples; i++)
        centers[i] + normals[i] * (s * widths[i]),
    ];

    Path band(double a, double b) {
      final top = edge(a);
      final bottom = edge(b).reversed;
      return Path()..addPolygon([...top, ...bottom], true);
    }

    final full = band(-0.5, 0.5);

    if (r.shadow > 0) {
      canvas.drawPath(
        full.shift(const Offset(0, 3)),
        Paint()
          ..color = Colors.black.withValues(alpha: r.shadow)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    canvas.drawPath(full, Paint()..color = _shadeAt(r.shades, 0.5));

    // shade across the ribbon in thin strips (slight overlap hides seams)
    for (var k = 0; k < _strips; k++) {
      final a = -0.5 + k / _strips;
      final b = -0.5 + (k + 1) / _strips + 0.01;
      canvas.drawPath(
        band(a, b.clamp(-0.5, 0.5)),
        Paint()..color = _shadeAt(r.shades, (k + 0.5) / _strips),
      );
    }

    if (r.shine > 0) {
      final line = Path()..addPolygon(edge(-0.3), false);
      canvas.drawPath(
        line,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = Colors.white.withValues(alpha: r.shine)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
      );
    }

    final lowerEdge = Path()..addPolygon(edge(0.5), false);
    canvas.drawPath(
      lowerEdge,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = Colors.black.withValues(alpha: 0.12),
    );
  }

  Color _shadeAt(List<Color> shades, double f) {
    if (shades.length == 1) return shades.first;
    final pos = f.clamp(0.0, 1.0) * (shades.length - 1);
    final i = pos.floor().clamp(0, shades.length - 2);
    return Color.lerp(shades[i], shades[i + 1], pos - i)!;
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter old) => old.ribbons != ribbons;
}

const _silver = [Color(0xFFFFFFFF), Color(0xFFE2E7EE), Color(0xFFF4F6F9)];

/// Curved ribbons framing the bottom of the login screen: red sweeping in
/// from the left, navy and gold from the right, with silver and pale trims.
/// Each enters from the screen edge on a diagonal and bends into a nearly
/// flat sweep along the bottom.
const loginRibbons = <Ribbon>[
  // silver arcs (the soft white "ring" behind the coloured ribbons)
  Ribbon(
    curve: [
      Offset(-0.06, 0.77),
      Offset(0.10, 0.875),
      Offset(0.30, 0.965),
      Offset(0.60, 0.985),
    ],
    startWidth: 0.035,
    endWidth: 0.02,
    shades: _silver,
    shine: 0,
    shadow: 0.07,
  ),
  Ribbon(
    curve: [
      Offset(0.40, 0.99),
      Offset(0.70, 0.97),
      Offset(0.90, 0.88),
      Offset(1.06, 0.765),
    ],
    startWidth: 0.02,
    endWidth: 0.035,
    shades: _silver,
    shine: 0,
    shadow: 0.07,
  ),

  // left: pale rose trim + red ribbon
  Ribbon(
    curve: [
      Offset(-0.06, 0.875),
      Offset(0.08, 0.955),
      Offset(0.25, 1.01),
      Offset(0.50, 1.035),
    ],
    startWidth: 0.03,
    endWidth: 0.02,
    shades: [Color(0xFFFCE6E6), Color(0xFFF2C2C5), Color(0xFFF9DCDD)],
    shine: 0.3,
    shadow: 0.05,
  ),
  Ribbon(
    curve: [
      Offset(-0.06, 0.805),
      Offset(0.10, 0.91),
      Offset(0.30, 0.99),
      Offset(0.62, 1.005),
    ],
    startWidth: 0.09,
    endWidth: 0.05,
    shades: [
      Color(0xFFFF8A8F),
      Color(0xFFEE3A45),
      Color(0xFFDA1E2E),
      Color(0xFFC3142A),
      Color(0xFF8E0A1A),
    ],
  ),

  // right: light blue edge, navy ribbon, gold ribbon
  Ribbon(
    curve: [
      Offset(0.36, 0.995),
      Offset(0.68, 0.975),
      Offset(0.89, 0.89),
      Offset(1.06, 0.785),
    ],
    startWidth: 0.012,
    endWidth: 0.018,
    shades: [Color(0xFFDCEAFB), Color(0xFFA9C9EE), Color(0xFFDCEAFB)],
    shine: 0,
    shadow: 0,
  ),
  Ribbon(
    curve: [
      Offset(0.38, 1.01),
      Offset(0.70, 0.995),
      Offset(0.90, 0.915),
      Offset(1.06, 0.815),
    ],
    startWidth: 0.05,
    endWidth: 0.09,
    shades: [
      Color(0xFF7FB1EC),
      Color(0xFF2A6CBE),
      Color(0xFF0D4790),
      Color(0xFF083571),
      Color(0xFF04214A),
    ],
  ),
  Ribbon(
    curve: [
      Offset(0.56, 1.045),
      Offset(0.80, 1.025),
      Offset(0.95, 0.965),
      Offset(1.06, 0.905),
    ],
    startWidth: 0.035,
    endWidth: 0.06,
    shades: [
      Color(0xFFFFF3CC),
      Color(0xFFF0D38C),
      Color(0xFFD6AA55),
      Color(0xFFB5862F),
      Color(0xFF7D5517),
    ],
  ),
];
