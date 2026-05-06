import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/verifi_theme.dart';
import 'screens/auth_gate.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

  // Initialize notifications after the UI is shown so unsupported platforms
  // or messaging setup issues do not block the app from launching.
  unawaited(_initializeServices());
}

Future<void> _initializeServices() async {
  final supportsMessaging =
      kIsWeb || defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  if (!supportsMessaging) {
    return;
  }

  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verifi',
      theme: VerifiTheme.lightTheme(),
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
