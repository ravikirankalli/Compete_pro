import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../dashboard_data.dart';

/// Bottom bar switching between Competitions, Healthcare and Examinations.
class SectionBar extends StatelessWidget {
  const SectionBar({
    super.key,
    required this.selected,
    required this.scale,
    required this.onSelect,
  });

  final DashboardSection selected;
  final double scale;
  final ValueChanged<DashboardSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14 * scale),
      padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE6EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220A1B3A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final section in DashboardSection.values)
            Expanded(
              child: _SectionButton(
                section: section,
                selected: section == selected,
                scale: scale,
                onTap: () => onSelect(section),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.section,
    required this.selected,
    required this.scale,
    required this.onTap,
  });

  final DashboardSection section;
  final bool selected;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = 64.0 * scale;
    const duration = Duration(milliseconds: 250);

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: duration,
                width: size,
                height: size,
                padding: EdgeInsets.all(selected ? 4 : 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: section.ring,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: selected
                          ? section.ring.last.withValues(alpha: 0.45)
                          : const Color(0x260A1B3A),
                      blurRadius: selected ? 14 : 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(size * 0.15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      radius: 0.9,
                      colors: [AppColors.white, Color(0xFFEDEFF4)],
                    ),
                  ),
                  child: Image.asset(
                    section.icon,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              SizedBox(height: 6 * scale),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  section.label,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 10.5 * scale,
                    letterSpacing: 0.3,
                    color: selected
                        ? AppColors.loginTitle
                        : AppColors.fieldHint,
                  ),
                ),
              ),
              SizedBox(height: 4 * scale),
              AnimatedContainer(
                duration: duration,
                width: selected ? 22 * scale : 0,
                height: 3 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: AppColors.brandGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
