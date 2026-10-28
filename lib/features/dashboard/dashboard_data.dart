import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _logos = 'assets/images/logos';

const _blue = Color(0xFF2A5FA8);
const _purple = Color(0xFF4B2E83);

class DashboardCardData {
  const DashboardCardData({
    required this.title,
    required this.headline,
    this.subtitle,
    required this.headlineColor,
    Color? subtitleColor,
    required this.image,
  }) : subtitleColor = subtitleColor ?? headlineColor;

  /// Human readable name, used in messages and menus.
  final String title;
  final String headline;
  final String? subtitle;
  final Color headlineColor;
  final Color subtitleColor;
  final String image;
}

enum DashboardSection {
  competitions(
    label: 'COMPETITIONS',
    title: 'Competitions',
    icon: '$_logos/nav_competitions.png',
    ring: [_blue, AppColors.navy],
    cards: [
      DashboardCardData(
        title: 'New Competitions',
        headline: 'NEW',
        subtitle: 'COMPETITIONS',
        headlineColor: AppColors.navy,
        image: '$_logos/new_competitions.png',
      ),
      DashboardCardData(
        title: 'Group Formation',
        headline: 'GROUP',
        subtitle: 'FORMATION',
        headlineColor: AppColors.navy,
        image: '$_logos/group_formation.png',
      ),
      DashboardCardData(
        title: 'Match Schedule',
        headline: 'MATCH',
        subtitle: 'SCHEDULE',
        headlineColor: AppColors.tileRed,
        image: '$_logos/match_schedule.png',
      ),
      DashboardCardData(
        title: 'Match Result',
        headline: 'MATCH',
        subtitle: 'RESULT',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileGold,
        image: '$_logos/match_result.png',
      ),
    ],
  ),
  healthcare(
    label: 'HEALTHCARE',
    title: 'Healthcare',
    icon: '$_logos/nav_healthcare.png',
    ring: [AppColors.navy, AppColors.red],
    cards: [
      DashboardCardData(
        title: 'Measurements',
        headline: 'MEASUREMENTS',
        headlineColor: AppColors.navy,
        image: '$_logos/measurements.png',
      ),
      DashboardCardData(
        title: 'Health Issues',
        headline: 'HEALTH',
        subtitle: 'ISSUES',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileRed,
        image: '$_logos/health_issues.png',
      ),
      DashboardCardData(
        title: 'Physical Strength',
        headline: 'PHYSICAL',
        subtitle: 'STRENGTH',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileGold,
        image: '$_logos/physical_strength.png',
      ),
    ],
  ),
  examinations(
    label: 'EXAMINATIONS',
    title: 'Examinations',
    icon: '$_logos/nav_examinations.png',
    ring: [AppColors.tileGoldLight, AppColors.tileGold],
    cards: [
      DashboardCardData(
        title: 'Exams Schedule',
        headline: 'EXAMS',
        subtitle: 'SCHEDULE',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileGold,
        image: '$_logos/exams_schedule.png',
      ),
      DashboardCardData(
        title: 'Students List',
        headline: 'STUDENTS',
        subtitle: 'LIST',
        headlineColor: AppColors.navy,
        subtitleColor: _purple,
        image: '$_logos/students_list.png',
      ),
      DashboardCardData(
        title: 'Teachers List',
        headline: 'TEACHERS',
        subtitle: 'LIST',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileRed,
        image: '$_logos/teachers_list.png',
      ),
      DashboardCardData(
        title: 'Exam Hall Settings',
        headline: 'EXAM HALL',
        subtitle: 'SETTINGS',
        headlineColor: AppColors.navy,
        subtitleColor: _blue,
        image: '$_logos/exam_hall_settings.png',
      ),
      DashboardCardData(
        title: 'Teachers Allocation',
        headline: 'TEACHERS',
        subtitle: 'ALLOCATION',
        headlineColor: AppColors.navy,
        subtitleColor: AppColors.tileGold,
        image: '$_logos/teachers_allocation.png',
      ),
      DashboardCardData(
        title: 'Material Upload',
        headline: 'MATERIAL',
        subtitle: 'UPLOAD',
        headlineColor: AppColors.navy,
        subtitleColor: _blue,
        image: '$_logos/material_upload.png',
      ),
      DashboardCardData(
        title: 'Valuation',
        headline: 'VALUATION',
        headlineColor: AppColors.tileRed,
        image: '$_logos/valuation.png',
      ),
    ],
  );

  const DashboardSection({
    required this.label,
    required this.title,
    required this.icon,
    required this.ring,
    required this.cards,
  });

  final String label;
  final String title;
  final String icon;
  final List<Color> ring;
  final List<DashboardCardData> cards;
}
