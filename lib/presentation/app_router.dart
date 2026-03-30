import 'package:flutter/material.dart';
import 'city_detail_screen.dart';
import 'forecast_screen.dart';

/// Arguments required to open the City Detail screen.
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

/// Type-safe route definitions using generics.
enum AppRoute<T> {
  home<void>(),
  forecast<void>(),
  cityDetail<CityDetailArgs>();

  const AppRoute();

  Route<dynamic> route(T args) {
    return MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) {
        switch (this) {
          case AppRoute.home:
            throw UnimplementedError('Home is set via MaterialApp.home');
          case AppRoute.forecast:
            return const ForecastScreen();
          case AppRoute.cityDetail:
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

/// Convenience extension on Navigator for type-safe routing.
extension AppNavigator on NavigatorState {
  Future<R?> pushRoute<R>(AppRoute<void> route) {
    return push<R>(route.route(null) as Route<R>);
  }

  Future<R?> pushRouteWithArgs<R, T>(AppRoute<T> route, T args) {
    return push<R>(route.route(args) as Route<R>);
  }
}
