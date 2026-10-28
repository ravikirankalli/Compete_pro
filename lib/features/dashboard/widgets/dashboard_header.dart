import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.topPadding,
    required this.scale,
    required this.onBell,
  });

  final double topPadding;
  final double scale;
  final VoidCallback onBell;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        boxShadow: [
          BoxShadow(
            color: Color(0x330A1B3A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 64 * scale,
        child: Row(
          children: [
            const SizedBox(width: 6),
            Builder(
              builder: (context) => IconButton(
                tooltip: 'Menu',
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 30 * scale,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'COMPETE PRO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontWeight: FontWeight.w700,
                  fontSize: 22 * scale,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: onBell,
              icon: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 28 * scale,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
