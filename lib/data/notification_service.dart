import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/// Service that handles local notification initialization and triggering.
///
/// Lives in the data layer because it communicates with the native OS
/// notification center — a platform-level data sink, similar to how
/// LocationService talks to GPS hardware.
///
/// This class is the ONLY place in the app that imports
/// flutter_local_notifications.
class NotificationService {
// The plugin instance — created once, reused for all notifications.
  f
  inal FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
// Track whether init() has been called to prevent double-initialization.
  bool _isInitialized = false;
  /// Initializes the notification plugin with platform-specific settings.
  ///
  /// MUST be called once before any notification can be shown.
  /// Safe to call multiple times — it checks the _isInitialized flag.
  Future<void> init() async {
    if (_isInitialized) return;
// --- Android Settings ---
// '@mipmap/ic_launcher' is the default app icon that Flutter generates.
// This icon appears in the notification shade and status bar.
// For a production app, you would create a dedicated small white icon.
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
// --- iOS Settings ---
// requestAlertPermission: triggers the "App wants to send notifications"
//   popup the first time a notification is triggered.
// requestBadgePermission: allows the app icon badge (the red number).
// requestSoundPermission: allows notification sounds.
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
// Combine both platform settings into one object.
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
// Initialize the plugin. This is where the iOS permission popup
// would appear (first time only).
    await _plugin.initialize(settings);
    _isInitialized = true;
  }
  /// Shows a weather alert notification.
  ///
  /// [title] — the notification headline (shown in bold).
  /// [body]  — the notification body text.
  ///
  /// This creates a HIGH priority notification that appears as a
  /// heads-up banner on both Android and iOS.
  Future<void> showWeatherAlert({
    required String title,
    required String body,
  }) async {
// Ensure the plugin is initialized before showing anything.
    if (!_isInitialized) await init();
    // --- Android Notification Details ---
    // channelId: groups notifications — users can mute this channel
    //   in Settings → Apps → travel_app → Notifications.
    // channelName: the human-readable name shown in Android settings.
    // importance: Importance.max makes it a heads-up notification
    //   (drops down from the top of the screen).
    // priority: Priority.high ensures it appears immediately.
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'weather_alerts',        // Channel ID (unique identifier)
      'Weather Alerts',        // Channel Name (shown in settings)
      channelDescription: 'Severe weather warnings and alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,          // Show the timestamp
    );

    // --- iOS Notification Details ---
    // presentAlert: shows the notification banner while the app is open.
    // presentBadge: updates the app icon badge number.
    // presentSound: plays the default notification sound.
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combine both platform details.
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Trigger the notification.
    // The first argument (0) is the notification ID — if you show
    // another notification with the same ID, it replaces the previous one.
    // Use different IDs if you want multiple notifications to stack.
    await _plugin.show(
      0,          // Notification ID
      title,      // Title (bold text)
      body,       // Body (description text)
      details,    // Platform-specific configuration
    );
  }

  /// Shows a generic notification with a custom ID.
  /// Useful for different notification types that shouldn't replace each other.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await init();

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'general',
      'General Notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(id, title, body, details);
  }
}