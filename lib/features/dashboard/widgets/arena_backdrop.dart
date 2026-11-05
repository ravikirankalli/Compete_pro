import 'package:flutter/material.dart';

/// The plain, soft colour wash behind a Competitions card.
///
/// Deliberately featureless: a blurred tint of the card's accent colour and
/// nothing else, so the heading and the illustration are the only things with
/// any detail. Painted rather than an image asset so it recolours itself per
/// card and stays smooth at any size.
class ArenaBackdrop extends StatelessWidget {
  const ArenaBackdrop({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            accent.withValues(alpha: 0.07),
            accent.withValues(alpha: 0.16),
          ],
          stops: const [0, 0.5, 1],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Soft off-centre glow, which is what keeps the flat tint from
          // looking like a solid block of colour.
          gradient: RadialGradient(
            center: const Alignment(0.35, -0.75),
            radius: 1.25,
            colors: [
              Colors.white.withValues(alpha: 0.85),
              Colors.white.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
