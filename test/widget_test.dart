// This is a basic Flutter widget test for the MDC Admin app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mdc_admin/main.dart';

void main() {
  testWidgets('App starts with role selector screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MDCApp());

    // Verify that the role selector screen is displayed
    expect(find.text('Choose Your Role'), findsOneWidget);
    expect(find.text('Admin Portal'), findsOneWidget);
    expect(find.text('Student Portal'), findsOneWidget);
  });

  testWidgets('Role selection navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MDCApp());

    // Tap on Admin Portal
    await tester.tap(find.text('Admin Portal'));
    await tester.pumpAndSettle();

    // Should navigate to login screen
    expect(find.text('Sign in to access the dashboard'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
