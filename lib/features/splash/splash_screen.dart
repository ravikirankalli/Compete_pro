import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/accent_divider.dart';
import '../../core/widgets/brand_wordmark.dart';
import '../../core/widgets/corner_slogan.dart';
import '../../core/widgets/decorative_curves.dart';
import '../../core/widgets/trust_attribution.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const emblemAsset = 'assets/images/trophy_emblem.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _displayDuration = Duration(milliseconds: 3200);
  static const _emblemAspect = 1024 / 798;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final Animation<double> _emblem = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _brand = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _details = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.5, 1, curve: Curves.easeOut),
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_displayDuration, _goToLogin);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(LoginScreen.backgroundAsset), context);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final w = size.width;
    final h = size.height;
    final s = (w / 390).clamp(0.85, 1.3);
    // slightly wider than the screen so the athletes bleed off the edges
    final emblemWidth = math.min(w * 1.12, h * 0.4 * _emblemAspect);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.white,
                      AppColors.coolWhite,
                      AppColors.white,
                    ],
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: DecorativeCurves(bands: splashCurveBands),
            ),
            Positioned(
              left: w * 0.07,
              top: math.max(padding.top + h * 0.075, h * 0.125),
              child: FadeTransition(
                opacity: _details,
                child: CornerSlogan(
                  lines: const ['PLAY', 'COMPETE', 'ACHIEVE', 'GROW'],
                  fontSize: 8.5 * s,
                  letterSpacing: 2.4 * s,
                ),
              ),
            ),
            Positioned(
              right: w * 0.05,
              top: padding.top + h * 0.012,
              child: FadeTransition(
                opacity: _details,
                child: CornerSlogan(
                  lines: const [
                    'DISCIPLINE',
                    'COMPETITION',
                    'PROGRESS',
                    'A BRIGHTER',
                    'TOMORROW',
                  ],
                  fontSize: 8 * s,
                  letterSpacing: 2.2 * s,
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: padding.top + h * 0.09),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _emblem,
                          child: ScaleTransition(
                            scale: Tween(begin: 0.9, end: 1.0).animate(_emblem),
                            child: SizedBox(
                              width: w,
                              height: emblemWidth / _emblemAspect,
                              child: OverflowBox(
                                minWidth: emblemWidth,
                                maxWidth: emblemWidth,
                                child: ShaderMask(
                                  blendMode: BlendMode.dstIn,
                                  shaderCallback: (rect) =>
                                      const LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                        stops: [0, 0.07, 0.93, 1],
                                      ).createShader(rect),
                                  child: Image.asset(
                                    SplashScreen.emblemAsset,
                                    width: emblemWidth,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.008),
                        FadeTransition(
                          opacity: _brand,
                          child: SlideTransition(
                            position: Tween(
                              begin: const Offset(0, 0.25),
                              end: Offset.zero,
                            ).animate(_brand),
                            child: Column(
                              children: [
                                BrandWordmark(width: w * 0.86),
                                SizedBox(height: 6 * s),
                                AccentDivider(
                                  width: w * 0.8,
                                  slashWidth: 16 * s,
                                  slashHeight: 6 * s,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.032),
                        FadeTransition(
                          opacity: _details,
                          child: Text(
                            'MORE THAN A GAME\nA BRIGHTER YOU',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5 * s,
                              letterSpacing: 4.6 * s,
                              height: 1.85,
                              color: AppColors.tagline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.025),
                  FadeTransition(
                    opacity: _details,
                    child: TrustAttribution(scale: s),
                  ),
                  SizedBox(height: h * 0.1 + padding.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
