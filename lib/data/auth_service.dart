import 'package:firebase_auth/firebase_auth.dart';
/// Service that handles all Firebase Authentication operations.
///
/// This class is the ONLY place in the app that imports firebase_auth.
/// It wraps Firebase's raw API into clean methods that return results
/// or throw descriptive exceptions.
///
/// Lives in the data layer because Firebase is an external service —
/// just like our weather API or SharedPreferences.
class AuthService {
// The FirebaseAuth singleton instance.
// This is provided by Firebase — we never create it manually.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  /// Returns the currently signed-in user, or null if not signed in.
  User? get currentUser => _auth.currentUser;
  /// Whether a user is currently signed in.
  bool get isSignedIn => _auth.currentUser != null;
  /// The auth state stream — emits User? whenever auth state changes.
  /// Used by AuthGate to reactively switch between login and dashboard.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  /// Creates a new user account with email and password.
  ///
  /// Firebase handles all the heavy lifting:
  ///   - Validates email format
  ///   - Ensures password is at least 6 characters
  ///   - Hashes the password (we never see the raw password again)
  ///   - Generates a unique user ID (UID)
  ///   - Creates an auth token for the session
  ///
  /// Throws a descriptive [Exception] on failure.
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // credential.user is the newly created User object.
      // It contains uid, email, displayName, etc.
      return credential.user;

    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException provides a 'code' string that tells us
      // exactly what went wrong. We map these to user-friendly messages.
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception('Registration failed. Please try again.');
    }
  }

  /// Signs in an existing user with email and password.
  ///
  /// On success, Firebase automatically persists the session —
  /// the user stays logged in across app restarts until they
  /// explicitly sign out.
  ///
  /// Throws a descriptive [Exception] on failure.
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;

    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception('Login failed. Please try again.');
    }
  }

  /// Signs out the current user.
  ///
  /// After this call, FirebaseAuth.instance.currentUser returns null,
  /// and the authStateChanges stream emits null — which triggers the
  /// AuthGate to swap to the login screen automatically.
  Future<void> logout() async {
    await _auth.signOut();
  }
  /// Sends a password reset email to the given address.
  ///
  /// Firebase handles the entire flow — generating a secure link,
  /// sending the email, and resetting the password when the user
  /// clicks the link. We just provide the email address.
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception('Failed to send reset email. Please try again.');
    }
  }
  /// Maps Firebase error codes to user-friendly messages.
  ///
  /// Firebase returns cryptic codes like 'wrong-password' or
  /// 'email-already-in-use'. Users need human-readable explanations.
  ///
  /// Security note: We intentionally do NOT say "password is wrong"
  /// separately from "user not found" — that would tell an attacker
  /// which emails have accounts. We use a generic message for both.
  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      // Security: Generic message for both — don't reveal which emails exist.
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}