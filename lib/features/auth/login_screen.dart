import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/widgets/accent_divider.dart';
import '../../core/widgets/brand_wordmark.dart';
import '../../core/widgets/corner_slogan.dart';
import '../../core/widgets/ribbon_layer.dart';
import '../../core/widgets/trust_attribution.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const backgroundAsset = 'assets/images/login_background.jpg';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    // TODO: replace with the Compete Pro authentication API call.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitting = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) =>
            DashboardScreen(organiserCode: _codeController.text.trim()),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _onForgotPassword() {
    _showMessage('Forgot password is not available yet.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.buttonStart,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final w = size.width;
    final h = size.height;
    final s = (w / 390).clamp(0.85, 1.3);
    final headerWidth = w * 0.62;
    final headerTop = padding.top + h * 0.014;
    final wordmarkBottom = headerTop + headerWidth * 0.2;
    final headerBottom = wordmarkBottom + 46 * s;
    // photo slightly wider than the screen so it reaches below the card top,
    // shifted so the organiser's head sits just below the wordmark
    // (head top is ~22% into the photo)
    final photoHeight = w * 1024 / 1015 * 1.15;
    final photoTop = (wordmarkBottom + 6 - photoHeight * 0.22).clamp(
      0.0,
      h * 0.12,
    );
    final gap = (h * 0.021).clamp(12.0, 22.0);
    final estimatedCardHeight = 48 + 115 * s + 2 * 54 + 52 + 48 + gap * 4.5;
    // keep the whole card on screen on short phones, without covering the
    // header
    final cardTop = math.max(
      math.min(h * 0.445, h - estimatedCardHeight - padding.bottom - 14),
      headerBottom + h * 0.08,
    );
    final photoBottom = photoTop + photoHeight;
    // white backdrop: high at the screen edges, dipping down behind the card
    final curveLeft = math.min(cardTop + h * 0.055, photoBottom - h * 0.025);
    final curveRight = math.min(cardTop + h * 0.065, photoBottom - h * 0.015);
    final curveMid = cardTop + h * 0.14;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: h),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: photoBottom,
                    child: _HeroPhoto(photoTop: photoTop),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _BackdropCurvePainter(
                          leftY: curveLeft,
                          rightY: curveRight,
                          midY: curveMid,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: w * 0.07,
                    top: headerTop,
                    child: _BrandHeader(width: headerWidth, scale: s),
                  ),
                  Positioned(
                    right: w * 0.045,
                    top: padding.top + h * 0.012,
                    child: CornerSlogan(
                      lines: const [
                        'DISCIPLINE',
                        'COMPETITION',
                        'PROGRESS',
                        'A BRIGHTER',
                        'TOMORROW',
                      ],
                      fontSize: 7.5 * s,
                      letterSpacing: 2 * s,
                      lineHeight: 1.75,
                      color: const Color(0xFF5E6470),
                    ),
                  ),
                  Positioned(
                    left: w * 0.065,
                    top: headerBottom - 8 * s,
                    child: CornerSlogan(
                      lines: const ['PLAY', 'COMPETE', 'ACHIEVE', 'GROW'],
                      fontSize: 7.5 * s,
                      letterSpacing: 2 * s,
                      lineHeight: 1.65,
                      color: const Color(0xFF5E6470),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: cardTop),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: _LoginCard(
                          formKey: _formKey,
                          codeController: _codeController,
                          passwordController: _passwordController,
                          passwordFocus: _passwordFocus,
                          obscurePassword: _obscurePassword,
                          submitting: _submitting,
                          onToggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          onSubmit: _submit,
                          onForgotPassword: _onForgotPassword,
                          scale: s,
                          gap: gap,
                        ),
                      ),
                      SizedBox(height: 14 + padding.bottom),
                    ],
                  ),
                  const Positioned.fill(
                    child: RibbonLayer(ribbons: loginRibbons),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.photoTop});

  final double photoTop;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // sky continuing above the photo (matches the photo's top edge)
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8F7F4),
                Color(0xFFF2F4F8),
                Color(0xFFD6E5F3),
                Color(0xFFAECDEC),
              ],
              stops: [0, 0.3, 0.55, 1],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: photoTop,
          bottom: 0,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [Colors.transparent, Colors.black],
              stops: [0, photoTop > 0 ? 0.12 : 0.0],
            ).createShader(rect),
            child: Image.asset(
              LoginScreen.backgroundAsset,
              fit: BoxFit.cover,
              alignment: const Alignment(-0.5, -1),
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        // brighten the sky behind the wordmark and slogans
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xB3FFFFFF), Color(0x00FFFFFF)],
              stops: [0, 0.3],
            ),
          ),
        ),
      ],
    );
  }
}

/// White curved backdrop under the photo: high at the screen edges and
/// dipping down (bowl-shaped) behind the card.
class _BackdropCurvePainter extends CustomPainter {
  _BackdropCurvePainter({
    required this.leftY,
    required this.rightY,
    required this.midY,
  });

  final double leftY;
  final double rightY;

  /// Height of the curve at the horizontal centre.
  final double midY;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final controlY = 2 * midY - (leftY + rightY) / 2;
    final dome = Path()
      ..moveTo(0, leftY)
      ..quadraticBezierTo(w / 2, controlY, w, rightY)
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(dome, const Color(0xFF0A1B3A), 6, false);

    final top = math.min(leftY, rightY);
    canvas.drawPath(
      dome,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFFEDF1F6), AppColors.white],
          stops: const [0, 0.12],
        ).createShader(Rect.fromLTRB(0, top, w, size.height)),
    );

    final rim = Path()
      ..moveTo(0, leftY)
      ..quadraticBezierTo(w / 2, controlY, w, rightY);
    canvas.drawPath(
      rim,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.white,
    );
    canvas.drawPath(
      rim.shift(const Offset(0, 4)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFFD9E0E9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );
  }

  @override
  bool shouldRepaint(covariant _BackdropCurvePainter old) =>
      old.leftY != leftY || old.rightY != rightY || old.midY != midY;
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.width, required this.scale});

  final double width;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandWordmark(width: width),
          SizedBox(height: 4 * scale),
          AccentDivider(
            width: width * 0.94,
            slashWidth: 12 * scale,
            slashHeight: 4.5 * scale,
            lineThickness: 1.1,
          ),
          SizedBox(height: 9 * scale),
          Text(
            'MORE THAN A GAME\nA BRIGHTER YOU',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.montserrat,
              fontWeight: FontWeight.w500,
              fontSize: 8.5 * scale,
              letterSpacing: 3.4 * scale,
              height: 1.7,
              color: AppColors.tagline,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.codeController,
    required this.passwordController,
    required this.passwordFocus,
    required this.obscurePassword,
    required this.submitting,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.scale,
    required this.gap,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final bool obscurePassword;
  final bool submitting;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final double scale;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // extra bottom room: the ribbons sweep across the card's lower corners
      padding: EdgeInsets.fromLTRB(22 * scale, 24 * scale, 22 * scale, 48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0A1B3A),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w700,
                fontSize: 30 * scale,
                letterSpacing: -0.6,
                height: 1.1,
                color: AppColors.loginTitle,
              ),
            ),
            SizedBox(height: 10 * scale),
            AccentDivider(
              width: 190 * scale,
              slashWidth: 12 * scale,
              slashHeight: 5 * scale,
              lineThickness: 1.1,
              leftLineColor: const Color(0xFF1B3B6F),
              rightLineColor: const Color(0xFF1B3B6F),
              slashColors: const [
                Color(0xFF1B3B6F),
                Color(0xFFDC2626),
                Color(0xFFEAB308),
              ],
            ),
            SizedBox(height: gap * 1.4),
            _BrandTextField(
              controller: codeController,
              hint: 'Organiser Code',
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => passwordFocus.requestFocus(),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your organiser code'
                  : null,
            ),
            SizedBox(height: gap),
            _BrandTextField(
              controller: passwordController,
              focusNode: passwordFocus,
              hint: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onSubmit(),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Please enter your password'
                  : null,
              suffix: IconButton(
                onPressed: onToggleObscure,
                tooltip: obscurePassword ? 'Show password' : 'Hide password',
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.fieldIcon,
                  size: 22,
                ),
              ),
            ),
            SizedBox(height: gap * 1.2),
            _GradientButton(
              label: 'Login',
              loading: submitting,
              onPressed: submitting ? null : onSubmit,
            ),
            SizedBox(height: gap * 0.3),
            TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.link,
                textStyle: const TextStyle(
                  fontFamily: AppFonts.inter,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.link,
                ),
              ),
              child: const Text('Forgot Password?'),
            ),
            SizedBox(height: gap * 0.6),
            TrustAttribution(
              scale: 0.78 * scale,
              textColor: AppColors.footerText,
              lineColor: AppColors.footerGold,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTextField extends StatelessWidget {
  const _BrandTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      cursorColor: AppColors.navy,
      style: const TextStyle(
        fontFamily: AppFonts.inter,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.loginTitle,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: AppFonts.inter,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.fieldHint,
        ),
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 8),
          child: Icon(icon, color: AppColors.fieldIcon, size: 24),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        suffixIcon: suffix,
        errorStyle: const TextStyle(
          fontFamily: AppFonts.inter,
          fontSize: 12,
          color: AppColors.error,
        ),
        enabledBorder: border(AppColors.fieldBorder),
        focusedBorder: border(AppColors.navyHighlight, 1.4),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, 1.4),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: AppColors.brandGradient,
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E0A1B3A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontFamily: AppFonts.inter,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
