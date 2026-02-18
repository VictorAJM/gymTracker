// Default smoke test — updated to use GymTrackerApp instead of the deleted MyApp.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/main.dart';

void main() {
  testWidgets('GymTrackerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GymTrackerApp()),
    );
    // The app should render without throwing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
