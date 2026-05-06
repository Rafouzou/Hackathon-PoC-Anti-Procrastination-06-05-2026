import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/verifi_button.dart';
import '../../theme/verifi_theme.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onLoginTap;

  const SignUpScreen({
    super.key,
    required this.onLoginTap,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.signUp(
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: VerifiSpacing.sm),
                Text(
                  'Join the fight against procrastination',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: VerifiColors.darkGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                // Name field
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a username',
                  ),
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Password field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Create a password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Confirm password field
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
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
                // Sign up button
                VerifiButton(
                  label: 'Sign Up',
                  onPressed: _handleSignUp,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: VerifiSpacing.md),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: widget.onLoginTap,
                      child: Text(
                        'Login',
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
