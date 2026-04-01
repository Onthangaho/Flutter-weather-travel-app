import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';
/// The Auth Gate is the first widget the app displays.
/// It listens to Firebase's auth state stream and decides
/// which screen to show:
///   - User logged in  → HomeScreen (the dashboard)
///   - User logged out → LoginScreen
///
/// This is a reactive pattern. We never manually navigate
/// between login and dashboard. The StreamBuilder automatically
/// swaps the screen when the auth state changes.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // authStateChanges() emits an event every time the user
      // signs in, signs out, or their token refreshes.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // --- LOADING STATE ---
        // While the stream is connecting (first frame), show a loading screen.
        // This prevents a flash of the login screen before Firebase
        // has checked if the user has a saved session from yesterday.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // --- AUTHENTICATED ---
        // snapshot.hasData means the User object is not null — logged in.
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // --- NOT AUTHENTICATED ---
        // No user data — show the login screen.
        return const LoginScreen();
      },
    );
  }
}