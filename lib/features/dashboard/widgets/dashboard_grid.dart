import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_fonts.dart';
import '../dashboard_data.dart';
import 'arena_backdrop.dart';
import 'edge_fade.dart';

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
        // Tall tiles, giving the illustration room to breathe. The height is
        // still capped to what the viewport can show, so a short screen
        // shrinks the tiles rather than overflowing the grid.
        final available =
            constraints.maxHeight - topPad - gap * (rows - 1) - 12;
        final tileHeight = math.max(
          150.0,
          math.min(tileWidth / 0.66, available / rows),
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
    final radius = BorderRadius.circular(14 * scale);
    // The heading sits top-left over the pale part of the arena wash, with the
    // illustration filling the rest of the card.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: data.accent.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: data.accent.withValues(alpha: 0.12),
          highlightColor: data.accent.withValues(alpha: 0.06),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ArenaBackdrop(accent: data.accent),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  11 * scale,
                  10 * scale,
                  11 * scale,
                  8 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.headline,
                      style: TextStyle(
                        fontFamily: AppFonts.condensed,
                        fontWeight: FontWeight.w700,
                        fontSize: 19 * scale,
                        height: 1.0,
                        letterSpacing: 0.2,
                        color: data.headlineColor,
                      ),
                    ),
                    if (data.subtitle != null)
                      Text(
                        data.subtitle!,
                        style: TextStyle(
                          fontFamily: AppFonts.condensed,
                          fontWeight: FontWeight.w700,
                          fontSize: 19 * scale,
                          height: 1.05,
                          letterSpacing: 0.2,
                          color: data.subtitleColor,
                        ),
                      ),
                    SizedBox(height: 4 * scale),
                    // Full width so the icon centres on the card, not on the
                    // space left over beside the heading.
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Image.asset(
                            data.image,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Accent border drawn last so it is never covered by the backdrop.
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: data.accent,
                      width: 2.2 * scale,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
