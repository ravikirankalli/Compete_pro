import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/trust_attribution.dart';
import '../../auth/login_screen.dart';
import '../dashboard_data.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    super.key,
    required this.organiserCode,
    required this.selected,
    required this.onSection,
  });

  final String? organiserCode;
  final DashboardSection selected;
  final ValueChanged<DashboardSection> onSection;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final navigator = Navigator.of(context);

    const labelStyle = TextStyle(
      fontFamily: AppFonts.inter,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: AppColors.loginTitle,
    );

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, padding.top + 24, 20, 22),
            decoration: const BoxDecoration(gradient: AppColors.brandGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Event Organiser',
                  style: TextStyle(
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                if (organiserCode != null && organiserCode!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    organiserCode!,
                    style: const TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final section in DashboardSection.values)
            ListTile(
              selected: section == selected,
              selectedTileColor: AppColors.fieldFill,
              leading: SizedBox.square(
                dimension: 30,
                child: Image.asset(section.icon, fit: BoxFit.contain),
              ),
              title: Text(
                section.title,
                style: labelStyle.copyWith(
                  fontWeight: section == selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
              onTap: () {
                navigator.pop();
                onSection(section);
              },
            ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.navy),
            title: const Text('Logout', style: labelStyle),
            onTap: () {
              navigator.pop();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: padding.bottom + 16),
            child: const TrustAttribution(
              scale: 0.75,
              textColor: AppColors.footerText,
              lineColor: AppColors.footerGold,
            ),
          ),
        ],
      ),
    );
  }
}
