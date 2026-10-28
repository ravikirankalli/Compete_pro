import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_fonts.dart';
import '../dashboard_data.dart';
import 'edge_fade.dart';
import 'tile_frame.dart';

/// Two-column grid of tall tiles (used by the Competitions section).
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
    required this.cards,
    required this.scale,
    required this.onTap,
  });

  final List<DashboardCardData> cards;
  final double scale;
  final ValueChanged<DashboardCardData> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = 18.0 * scale;
        final gap = 14.0 * scale;
        final topPad = 18.0 * scale;
        final rows = (cards.length / 2).ceil();
        final tileWidth = (constraints.maxWidth - hPad * 2 - gap) / 2;
        // tiles are ~0.68 (w/h); shrink height if the screen is short
        final available =
            constraints.maxHeight - topPad - gap * (rows - 1) - 12;
        final tileHeight = math.max(
          150.0,
          math.min(tileWidth / 0.68, available / rows),
        );

        return EdgeFade(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, topPad, hPad, 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: math.max(0, constraints.maxHeight - topPad - 12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var row = 0; row < rows; row++) ...[
                    if (row > 0) SizedBox(height: gap),
                    Row(
                      children: [
                        for (var col = 0; col < 2; col++) ...[
                          if (col > 0) SizedBox(width: gap),
                          SizedBox(
                            width: tileWidth,
                            height: tileHeight,
                            child: row * 2 + col < cards.length
                                ? _GridTile(
                                    data: cards[row * 2 + col],
                                    scale: scale,
                                    onTap: () => onTap(cards[row * 2 + col]),
                                  )
                                : null,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.data,
    required this.scale,
    required this.onTap,
  });

  final DashboardCardData data;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TileFrame(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          8 * scale,
          12 * scale,
          8 * scale,
          10 * scale,
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                data.headline,
                style: TextStyle(
                  fontFamily: AppFonts.condensed,
                  fontWeight: FontWeight.w700,
                  fontSize: 30 * scale,
                  height: 1.0,
                  letterSpacing: 0.3,
                  color: data.headlineColor,
                ),
              ),
            ),
            if (data.subtitle != null) ...[
              SizedBox(height: 2 * scale),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.subtitle!,
                  style: TextStyle(
                    fontFamily: AppFonts.condensed,
                    fontWeight: FontWeight.w600,
                    fontSize: 17 * scale,
                    height: 1.1,
                    letterSpacing: 0.4,
                    color: data.subtitleColor,
                  ),
                ),
              ),
            ],
            SizedBox(height: 8 * scale),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4 * scale),
                child: Image.asset(
                  data.image,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
