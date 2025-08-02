// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/main.dart';

void main() {
  testWidgets('TaskPulse app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskPulseApp());

    // Verify that our app shows the correct content.
    expect(
      find.text('TaskPulse'),
      findsNWidgets(2),
    ); // One in AppBar, one in body
    expect(find.text('Task Management App'), findsOneWidget);
    expect(find.text('Dependencies initialized successfully!'), findsOneWidget);
  });
}
