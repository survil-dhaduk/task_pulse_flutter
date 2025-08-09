// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/services/service_locator.dart';
import 'package:task_pulse/main.dart';

void main() {
  testWidgets('TaskPulse app smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initDependencies();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskPulseApp());

    // App bar title should be present
    expect(find.text('TaskPulse'), findsOneWidget);
    // Initially shows a loading indicator while tasks load
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
