import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../dashboard_data.dart';
import 'edge_fade.dart';
import 'tile_frame.dart';

/// Scrollable list with one wide card per row (Healthcare, Examinations).
class DashboardCardList extends StatelessWidget {
  const DashboardCardList({
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
        final gap = 16.0 * scale;
        final topPad = 18.0 * scale;
        final cardHeight = math.min(
          math.max(128.0, (constraints.maxWidth - hPad * 2) * 0.42),
          172.0 * scale,
        );

        return EdgeFade(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, topPad, hPad, 16 * scale),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: math.max(
                  0,
                  constraints.maxHeight - topPad - 16 * scale,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) SizedBox(height: gap),
                    SizedBox(
                      height: cardHeight,
                      child: _WideCard(
                        data: cards[i],
                        scale: scale,
                        onTap: () => onTap(cards[i]),
                      ),
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

class _WideCard extends StatelessWidget {
  const _WideCard({
    required this.data,
    required this.scale,
    required this.onTap,
  });

  final DashboardCardData data;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle(Color color) => TextStyle(
      fontFamily: AppFonts.condensed,
      fontWeight: FontWeight.w700,
      fontSize: 34 * scale,
      height: 1.05,
      letterSpacing: 0.4,
      color: color,
    );

    return TileFrame(
      radius: 18,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20 * scale,
          14 * scale,
          14 * scale,
          14 * scale,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 11,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.headline,
                      style: titleStyle(data.headlineColor),
                    ),
                  ),
                  if (data.subtitle != null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.subtitle!,
                        style: titleStyle(data.subtitleColor),
                      ),
                    ),
                  SizedBox(height: 10 * scale),
                  Container(
                    width: 46 * scale,
                    height: 4 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: AppColors.brandGradient,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10 * scale),
            Expanded(
              flex: 9,
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
