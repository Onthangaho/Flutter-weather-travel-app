import 'package:geolocator/geolocator.dart';

/// Service that handles GPS location access and the permission flow.
///
/// This class lives in the data layer because it accesses device hardware
/// (the GPS sensor), which is a data source just like an API or database.
///
/// It handles the full permission dance:
///   1. Check if GPS hardware is enabled
///   2. Check if the app has permission
///   3. Request permission if needed
///   4. Handle permanent denials gracefully
///   5. Return coordinates on success
class LocationService {
  /// Determines the current position of the device.
  ///
  /// Returns a [Position] object with latitude and longitude on success.
  /// Throws a descriptive [Exception] at each failure point so the caller
  /// can display a meaningful error to the user.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // ============================================================
    // GATE 1: Is the GPS hardware turned on?
    // ============================================================
    // The user might have GPS disabled system-wide (airplane mode,
    // battery saver, or just manually turned off). We check first
    // before trying to use it.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // GPS is off at the system level. We cannot turn it on for them.
      // We can only tell them to go turn it on.
      throw Exception(
        'Location services are disabled. Please enable GPS in your device settings.',
      );
    }

    // ============================================================
    // GATE 2: Does this app have permission to use GPS?
    // ============================================================
    // Even if GPS is on, this specific app might not have been granted
    // access. We need to check our permission status.
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // We don't have permission yet — this triggers the native popup.
      // On Android: "Allow travel_app to access this device's location?"
      // On iOS: "travel_app would like to use your location" with our
      //         Info.plist description string shown below.
      //
      // The user sees this ONLY because they just tapped the location
      // button — they know WHY we're asking. This is the "latest
      // possible time" principle.
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // User tapped "Deny" on the popup.
        // We respect their choice and throw an error.
        throw Exception(
          'Location permission denied. Tap the location button to try again.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // The user previously tapped "Don't Allow" (iOS) or "Deny" twice
      // (Android). The OS will NEVER show the permission popup again.
      // The only way to fix this is for the user to manually go to
      // Settings → Apps → travel_app → Permissions → Location → Allow.
      //
      // We can help them get there with Geolocator.openAppSettings()
      // but for now we just explain the situation.
      throw Exception(
        'Location permission is permanently denied. '
            'Please enable it in your device settings.',
      );
    }

// ============================================================
// GATE 3: All clear — get the actual coordinates!
// ============================================================
// locationSettings controls the accuracy and platform behavior.
// LocationAccuracy.high uses GPS (accurate to ~5 meters).
// LocationAccuracy.low uses cell towers/WiFi (~100 meters) and
// uses less battery.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}