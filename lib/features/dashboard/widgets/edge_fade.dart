import 'package:flutter/material.dart';

/// Softly fades scrolling content out at the top and bottom edges.
class EdgeFade extends StatelessWidget {
  const EdgeFade({super.key, required this.child, this.extent = 18});

  final Widget child;
  final double extent;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
        final f = bounds.height <= 0
            ? 0.0
            : (extent / bounds.height).clamp(0.0, 0.3);
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0, f, 1 - f, 1],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
