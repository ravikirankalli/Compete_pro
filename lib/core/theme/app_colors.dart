import 'package:flutter/material.dart';

/// Compete Pro brand palette (from the splash / login design specification).
abstract final class AppColors {
  // Backgrounds
  static const white = Color(0xFFFFFFFF);
  static const coolWhite = Color(0xFFF8FAFD);
  static const lightGrey = Color(0xFFE9EDF2);
  static const silverWhite = Color(0xFFF1F3F6);

  // Wordmark
  static const navy = Color(0xFF062A59);
  static const navyDark = Color(0xFF071A38);
  static const navyHighlight = Color(0xFF174E87);
  static const red = Color(0xFFD7192D);
  static const redDark = Color(0xFFA90D20);
  static const redHighlight = Color(0xFFED3745);

  // Accent slashes under the wordmark
  static const slashNavy = Color(0xFF123D76);
  static const slashRed = Color(0xFFC91D2B);
  static const slashGold = Color(0xFFB88938);

  // Text
  static const tagline = Color(0xFF454B57);
  static const slogan = Color(0xFF858A93);
  static const institution = Color(0xFF16284A);
  static const institutionGold = Color(0xFFB99550);

  // Decorative curves
  static const curveRed = Color(0xFFC91422);
  static const curveRedDark = Color(0xFF8F0714);
  static const paleRose = Color(0xFFF4D9D7);
  static const curveNavy = Color(0xFF062B60);
  static const curveBlue = Color(0xFF0758A6);
  static const paleBlue = Color(0xFFDCEAFB);
  static const curveGold = Color(0xFFC79A43);
  static const curveGoldLight = Color(0xFFE4C37D);

  // Login form
  static const loginTitle = Color(0xFF0A192F);
  static const fieldFill = Color(0xFFF4F6F9);
  static const fieldBorder = Color(0xFFE2E8F0);
  static const fieldIcon = Color(0xFF475569);
  static const fieldHint = Color(0xFF64748B);
  static const buttonStart = Color(0xFF0A1B3A);
  static const buttonEnd = Color(0xFFC51E2E);
  static const link = Color(0xFF2563EB);
  static const footerText = Color(0xFF0F172A);
  static const footerGold = Color(0xFFC5A059);
  static const error = Color(0xFFB42318);

  /// Navy → crimson brand gradient (login button, dashboard header).
  static const brandGradient = LinearGradient(
    colors: [buttonStart, Color(0xFF1C2E5C), buttonEnd],
    stops: [0, 0.5, 1],
  );

  // Dashboard
  static const dashboardBackground = Color(0xFFF3F5F9);
  static const tileGold = Color(0xFFB8862B);
  static const tileGoldLight = Color(0xFFE8C77A);
  static const tileRed = Color(0xFFA50E1F);

  /// Per-card accents for the Competitions grid: each card carries its own
  /// border, heading and backdrop tint.
  static const tileBlue = Color(0xFF2A5FA8);
  static const tileCrimson = Color(0xFF9E1B32);
  static const tileAmber = Color(0xFFC8912C);
  static const tileGreen = Color(0xFF1F7A4C);
}
