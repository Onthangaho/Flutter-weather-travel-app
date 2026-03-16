import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:travel_app/main.dart';

void main() {
  testWidgets('App shell renders correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const TravelApp());

    // Verify the AppBar title is present.
    expect(find.text('Weather & Travel'), findsOneWidget);

    // Verify the welcome text is present.
    expect(find.text('Welcome to Weather & Travel App!'), findsOneWidget);

    // Verify the FloatingActionButton is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify the AppBar action icons are present.
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.travel_explore), findsOneWidget);
  });
}
