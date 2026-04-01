import 'package:flutter/material.dart';
import '../data/auth_service.dart';
/// Provider that manages authentication state and operations.
///
/// Handles the loading lifecycle for login, registration, and logout.
/// Delegates all Firebase operations to AuthService.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
// --- State variables ---
  bool _isLoading = false;
  String? _errorMessage;
// --- Public getters ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  /// The currently signed-in user's email, or null.
  String? get userEmail => _authService.currentUser?.email;
  /// The currently signed-in user's UID, or null.
  String? get userId => _authService.currentUser?.uid;
// Constructor — receives service via dependency injection
  AuthProvider(this._authService);
  /// Clears any previous error message.
  /// Call this when the user starts typing after an error,
  /// so the error banner disappears.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  /// Registers a new user with email and password.
  ///
  /// On success, Firebase automatically signs them in,
  /// which triggers the AuthGate stream → dashboard appears.
  /// We don't need to navigate manually.
  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(email, password);
      return true; // Success — AuthGate handles the screen swap
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs in an existing user with email and password.
  ///
  /// On success, the AuthGate stream detects the new user
  /// and automatically swaps to the dashboard.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out the current user.
  ///
  /// After this call, the AuthGate stream emits null,
  /// and the login screen automatically appears.
  Future<void> logout() async {
    await _authService.logout();
    // No need to notifyListeners or navigate —
    // the AuthGate StreamBuilder handles everything.
  }

  /// Sends a password reset email.
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}