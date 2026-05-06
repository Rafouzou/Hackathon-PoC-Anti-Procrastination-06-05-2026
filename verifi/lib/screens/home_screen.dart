import 'package:flutter/material.dart';
import '../theme/verifi_theme.dart';
import '../services/auth_service.dart';
import '../widgets/verifi_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(VerifiSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: VerifiSpacing.md),
              Text(
                'App coming soon...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: VerifiSpacing.lg),
              VerifiButton(
                label: 'Logout',
                onPressed: () async {
                  await authService.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
