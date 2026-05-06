import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VerifiUser?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        return _showLogin
            ? LoginScreen(
                onSignUpTap: () {
                  setState(() {
                    _showLogin = false;
                  });
                },
              )
            : SignUpScreen(
                onLoginTap: () {
                  setState(() {
                    _showLogin = true;
                  });
                },
              );
      },
    );
  }
}
