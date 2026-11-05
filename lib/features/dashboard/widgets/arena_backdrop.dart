import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The pale stadium wash behind a Competitions card.
///
/// Painted rather than photographic so it tints itself from the card's accent
/// colour and stays crisp at any size. Everything here is deliberately low
/// contrast: the heading and the illustration have to stay the loudest things
/// on the card.
class ArenaBackdrop extends StatelessWidget {
  const ArenaBackdrop({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArenaPainter(accent),
      isComplex: true,
      willChange: false,
      size: Size.infinite,
    );
  }
}

class _ArenaPainter extends CustomPainter {
  _ArenaPainter(this.accent);

  final Color accent;

  /// Horizon: above it the stand, below it the pitch.
  static const _horizon = 0.56;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    // Base wash, lightest at the top so the heading always sits on near-white.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            accent.withValues(alpha: 0.05),
            accent.withValues(alpha: 0.13),
          ],
          stops: const [0, 0.55, 1],
        ).createShader(rect),
    );

    _paintStand(canvas, w, h);
    _paintPitch(canvas, w, h);
    _paintFloodlight(canvas, w, h);
  }

  /// Tiered stand with a faint speckle of crowd.
  void _paintStand(Canvas canvas, double w, double h) {
    final horizonY = h * _horizon;

    for (var tier = 0; tier < 3; tier++) {
      final top = horizonY * (0.30 + tier * 0.20);
      canvas.drawRect(
        Rect.fromLTRB(0, top, w, top + horizonY * 0.16),
        Paint()..color = accent.withValues(alpha: 0.045 + tier * 0.012),
      );
    }

    // Deterministic seed: the backdrop must not shimmer on rebuild.
    final random = math.Random(7);
    final dot = Paint();
    final dotCount = (w * h / 420).clamp(40, 190).toInt();

    for (var i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * w;
      final y = horizonY * (0.26 + random.nextDouble() * 0.70);
      dot.color = accent.withValues(alpha: 0.05 + random.nextDouble() * 0.07);
      canvas.drawCircle(Offset(x, y), 0.9 + random.nextDouble() * 1.1, dot);
    }
  }

  /// Pitch band with a centre line and circle, drawn very faintly.
  void _paintPitch(Canvas canvas, double w, double h) {
    final horizonY = h * _horizon;
    final pitch = Rect.fromLTRB(0, horizonY, w, h);

    canvas.drawRect(
      pitch,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accent.withValues(alpha: 0.10),
            accent.withValues(alpha: 0.04),
          ],
        ).createShader(pitch),
    );

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.white.withValues(alpha: 0.55);

    final centreY = horizonY + (h - horizonY) * 0.46;
    canvas.drawLine(Offset(0, centreY), Offset(w, centreY), line);
    canvas.drawCircle(Offset(w / 2, centreY), w * 0.17, line);
  }

  /// Soft glow from the top corner, as if a floodlight were off frame.
  void _paintFloodlight(Canvas canvas, double w, double h) {
    final centre = Offset(w * 0.78, -h * 0.10);
    final radius = w * 0.95;

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.75),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: centre, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_ArenaPainter oldDelegate) => oldDelegate.accent != accent;
}
