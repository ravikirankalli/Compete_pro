import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const CompeteProApp());
}

class CompeteProApp extends StatelessWidget {
  const CompeteProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compete Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          primary: AppColors.navy,
          secondary: AppColors.red,
          surface: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: AppFonts.inter,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.navy,
          selectionHandleColor: AppColors.navy,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
