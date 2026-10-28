import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:compete_pro/features/auth/login_screen.dart';
import 'package:compete_pro/features/dashboard/dashboard_screen.dart';
import 'package:compete_pro/main.dart';

void main() {
  testWidgets('splash shows branding then moves to login', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const CompeteProApp());

    expect(find.text('MORE THAN A GAME\nA BRIGHTER YOU'), findsOneWidget);
    expect(find.text('Andhra Educational Trust'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Organiser Code'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('dashboard shows tiles and quick actions', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('COMPETE PRO'), findsOneWidget);
    for (final label in ['COMPETITIONS', 'FORMATION', 'SCHEDULE', 'RESULT']) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text('HEALTHCARE'), findsOneWidget);
    expect(find.text('EXAMINATIONS'), findsOneWidget);

    await tester.tap(find.text('SCHEDULE'));
    await tester.pump();
    expect(find.text('Match Schedule is coming soon.'), findsOneWidget);
  });

  testWidgets('bottom bar switches to healthcare and examinations', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('HEALTHCARE'));
    await tester.pumpAndSettle();
    for (final label in ['MEASUREMENTS', 'ISSUES', 'STRENGTH']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('FORMATION'), findsNothing);

    await tester.tap(find.text('EXAMINATIONS'));
    await tester.pumpAndSettle();
    for (final label in [
      'EXAMS',
      'STUDENTS',
      'EXAM HALL',
      'ALLOCATION',
      'MATERIAL',
      'VALUATION',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('MEASUREMENTS'), findsNothing);

    await tester.scrollUntilVisible(find.text('VALUATION'), 200);
    await tester.tap(find.text('VALUATION'));
    await tester.pump();
    expect(find.text('Valuation is coming soon.'), findsOneWidget);
  });

  testWidgets('login validates empty fields', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.tap(find.text('Login').last);
    await tester.pump();

    expect(find.text('Please enter your organiser code'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
