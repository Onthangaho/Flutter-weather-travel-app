import 'package:flutter/material.dart';
import 'city_detail_screen.dart';
import 'forecast_screen.dart';

// ================================================================
// STEP 1: Define argument classes for routes that need data
// ================================================================
// Instead of passing raw Maps or loose strings, we create a
// dedicated class for each route's arguments. This is the "contract"
// that the sending screen must fulfill.

/// Arguments required to open the City Detail screen.
/// Every field is typed and named — no guessing, no casting.
class CityDetailArgs {
  final String cityName;
  final String country;
  final String temperature;
  final String condition;

  const CityDetailArgs({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
  });
}

// ================================================================
// STEP 2: Define the routes enum with generics
// ================================================================
// Each enum value has a generic type <T> that declares what
// argument type that route expects.
//
// - <void> means the route takes NO arguments
// - <CityDetailArgs> means you MUST pass a CityDetailArgs object
//
// If you try to navigate to 'cityDetail' without passing
// CityDetailArgs, the compiler refuses to build. That's the magic.
enum AppRoute<T> {
  // Routes that take NO arguments use <void>
  home<void>(),
  forecast<void>(),

  // Routes that REQUIRE arguments declare the type
  cityDetail<CityDetailArgs>();

  // The const constructor — required for enums
  const AppRoute();

  // ================================================================
  // STEP 3: The route builder method
  // ================================================================
  // This method takes the argument (typed as T) and returns a
  // MaterialPageRoute that builds the correct screen.
  //
  // The key insight: because T is declared per-enum-value,
  // Dart KNOWS that if you call AppRoute.cityDetail.route(args),
  // then 'args' MUST be a CityDetailArgs. If you pass a String,
  // the compiler rejects it.

  Route<dynamic> route(T args) {
    return MaterialPageRoute(
      // settings: stores the route name for debugging/analytics
      settings: RouteSettings(name: name),
      builder: (context) {
        // Match the enum value to the correct screen
        switch (this) {
          case AppRoute.home:
            // Home is handled by MaterialApp's 'home' property,
            // but we include it for completeness
            throw UnimplementedError('Home is set via MaterialApp.home');

          case AppRoute.forecast:
            return const ForecastScreen();

          case AppRoute.cityDetail:
            // 'args' is guaranteed to be CityDetailArgs here
            // because this enum value was declared as <CityDetailArgs>
            final cityArgs = args as CityDetailArgs;
            return CityDetailScreen(
              cityName: cityArgs.cityName,
              country: cityArgs.country,
              temperature: cityArgs.temperature,
              condition: cityArgs.condition,
            );
        }
      },
    );
  }
}

// ================================================================
// STEP 4: A convenience extension on Navigator
// ================================================================
// This adds a .pushRoute() method to NavigatorState so we can
// write: Navigator.of(context).pushRoute(AppRoute.forecast)
// instead of the longer form.
extension AppNavigator on NavigatorState {
  /// Push a route that takes NO arguments (void routes)
  Future<R?> pushRoute<R>(AppRoute<void> route) {
    // Fix 1: Renamed parameter to 'route' (was 'Approute')
    // Fix 2: Cast the return to Route<R>
    return push<R>(route.route(null) as Route<R>);
  }

  /// Push a route that REQUIRES arguments
  Future<R?> pushRouteWithArgs<R, T>(AppRoute<T> route, T args) {
    // Fix 2: Cast the return to Route<R>
    return push<R>(route.route(args) as Route<R>);
  }
}
