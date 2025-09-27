// This is a basic Flutter widget test for the MDC Admin app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mdc_admin/main.dart';
import 'package:mdc_admin/viewmodels/auth_viewmodel.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
        child: const MaterialApp(home: AdminApp()),
      ),
    );

    // Verify that the login screen shows the correct title
    expect(find.text('MDC Admin Portal'), findsOneWidget);
    expect(find.text('Sign in to access the dashboard'), findsOneWidget);

    // Verify that email and password fields are present
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verify that the user type dropdown is present
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Admin Login'), findsOneWidget);

    // Verify that the login button is present
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('User type selection works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
        child: const MaterialApp(home: AdminApp()),
      ),
    );

    // Initially shows "Student Login"
    expect(find.text('Student Login'), findsOneWidget);

    // Tap the dropdown to open it
    await tester.tap(find.text('Student Login'));
    await tester.pumpAndSettle();

    // Select "Admin Login"
    await tester.tap(find.text('Admin Login').last);
    await tester.pumpAndSettle();

    // Verify the selection changed
    expect(find.text('Admin Login'), findsOneWidget);
    expect(find.text('Access Admin Dashboard'), findsOneWidget);
  });
}
