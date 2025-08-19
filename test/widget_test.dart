// Basic widget test for Groshly Customer App
// This test verifies that the app loads correctly

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:groshly_customer_app/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: GroshlyApp()));

    // Verify that the app loads without throwing an error
    // The splash screen should be visible initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
