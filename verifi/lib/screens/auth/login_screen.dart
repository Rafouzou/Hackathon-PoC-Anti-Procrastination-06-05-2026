import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/verifi_button.dart';
import '../../theme/verifi_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignUpTap;

  const LoginScreen({
    super.key,
    required this.onSignUpTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.signIn(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VerifiColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(VerifiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  'Welcome to\nVerifi',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: VerifiSpacing.sm),
                Text(
                  'Fight procrastination together',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: VerifiColors.darkGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                // Email field
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose your username',
                  ),
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Password field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Error message
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(VerifiSpacing.sm),
                    decoration: BoxDecoration(
                      color: VerifiColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(VerifiRadius.small),
                      border: Border.all(color: VerifiColors.error),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: VerifiColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: VerifiSpacing.lg),
                // Login button
                VerifiButton(
                  label: 'Login',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: widget.onSignUpTap,
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VerifiColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
