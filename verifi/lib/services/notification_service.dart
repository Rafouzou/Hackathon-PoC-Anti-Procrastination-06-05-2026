import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  Future<void> initialize() async {
    try {
      // Request permission
      await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      final token = await _fcm.getToken();
      debugPrint('FCM Token: $token');

      // Handle incoming messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received message: ${message.notification?.title}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Message opened: ${message.notification?.title}');
      });
    } catch (e) {
      debugPrint('FCM init skipped/failed: $e');
    }
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  Future<void> saveTokenToFirestore(String uid) async {
    final token = await getToken();
    if (token != null) {
      // Save to Firestore in services/notification_service.dart
      // This will be connected to user profile
    }
  }
}
