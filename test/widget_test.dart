import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:travel_app/main.dart';

void main() {
  testWidgets('Dashboard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelApp());
// Verify welcome text 
    expect(find.text('Welcome Back!'), findsOneWidget);
        expect(find.text('Check the weather in your saved cities.'), findsOneWidget);
// Verify current weather row 
    expect(find.text('28°C — Sunny'), findsOneWidget);
    expect(find.text('Nairobi, Kenya'), findsOneWidget);
// Verify saved cities header 
    expect(find.text('Saved Cities'), findsOneWidget);
    expect(find.text('6 cities'), findsOneWidget);
// Verify city tiles are present 
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
// Verify FAB exists 
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
  testWidgets('FAB adds a city', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelApp());
// Tap the FAB 
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
// Verify count updated 
    expect(find.text('7 cities'), findsOneWidget);
  });
}