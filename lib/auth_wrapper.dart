import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_pro/screens/login_screen.dart';
import 'package:login_pro/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Oops!! Something went wrong')),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case ConnectionState.active:
          case ConnectionState.none:
            User? user = snapshot.data;
            if (user == null) {
              return const LoginScreen();  // Make sure this screen exists
            } else {
              return const HomeScreen();   // Ensure HomeScreen is implemented correctly
            }
          case ConnectionState.done:
            return const Scaffold(
              body: Center(child: Text('Stream Finished')),
            );
        }
      },
    );
  }
}

