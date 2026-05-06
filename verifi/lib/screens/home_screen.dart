import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/verifi_theme.dart';
import 'tasks/task_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _authService = AuthService();

  final List<Widget> _screens = [
    const TaskListScreen(),
    const _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signOut(),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final email = user?.email;
    final username = email != null
        ? email.replaceAll('@verifi.local', '')
        : 'User';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VerifiSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: VerifiColors.yellow,
              child: Icon(
                Icons.person,
                size: 48,
                color: VerifiColors.black,
              ),
            ),
            const SizedBox(height: VerifiSpacing.md),
            Text(
              username,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: VerifiSpacing.md),
            Text(
              'Profile & Settings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: VerifiColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: VerifiSpacing.lg),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: VerifiColors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
