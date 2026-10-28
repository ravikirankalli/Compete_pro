import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import 'dashboard_data.dart';
import 'widgets/dashboard_card_list.dart';
import 'widgets/dashboard_drawer.dart';
import 'widgets/dashboard_grid.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/section_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.organiserCode,
    this.initialSection = DashboardSection.competitions,
  });

  final String? organiserCode;
  final DashboardSection initialSection;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardSection _section = widget.initialSection;

  void _select(DashboardSection section) {
    if (section != _section) setState(() => _section = section);
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature is coming soon.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.buttonStart,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final w = MediaQuery.sizeOf(context).width;
    final s = (w / 390).clamp(0.85, 1.25);
    final cards = _section.cards;

    return PopScope(
      canPop: _section == DashboardSection.competitions,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(DashboardSection.competitions);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.dashboardBackground,
          drawer: DashboardDrawer(
            organiserCode: widget.organiserCode,
            selected: _section,
            onSection: _select,
          ),
          body: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.dashboardBackground, AppColors.white],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  DashboardHeader(
                    topPadding: padding.top,
                    scale: s,
                    onBell: () => _comingSoon('Notifications'),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 0.03),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_section),
                        child: _section == DashboardSection.competitions
                            ? DashboardGrid(
                                cards: cards,
                                scale: s,
                                onTap: (card) => _comingSoon(card.title),
                              )
                            : DashboardCardList(
                                cards: cards,
                                scale: s,
                                onTap: (card) => _comingSoon(card.title),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6 * s),
                  SectionBar(selected: _section, scale: s, onSelect: _select),
                  SizedBox(height: math.max(padding.bottom, 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
