import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:travel_app/main.dart';
import 'package:travel_app/app_router.dart';

void main() {
  testWidgets('Dashboard renders and shows cities', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelApp());

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('Tapping city tile navigates to detail screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(const TravelApp());
// Tap the Paris tile
        await tester.tap(find.text('Paris'));
        await tester.pumpAndSettle();
// Verify detail screen loaded with Paris data
        expect(find.text('Paris Details'), findsOneWidget);
        expect(find.text('France'), findsOneWidget);
        expect(find.text('18°C'), findsOneWidget);
        expect(find.text('Cloudy'), findsOneWidget);
      });
  testWidgets('Calendar icon navigates to forecast screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(const TravelApp());
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
        expect(find.text('Weekly Forecast'), findsOneWidget);
        expect(find.text('Monday'), findsOneWidget);
      });
  testWidgets('Back button returns from detail screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(const TravelApp());
// Navigate to detail
        await tester.tap(find.text('Tokyo'));
        await tester.pumpAndSettle();
        expect(find.text('Tokyo Details'), findsOneWidget);
// Tap back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
// Verify we're back on the dashboard
        expect(find.text('Welcome Back!'), findsOneWidget);
      });
}