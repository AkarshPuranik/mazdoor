import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mazdoor/Onboarding_Screen.dart';
import 'package:mazdoor/home_screen.dart';
import 'package:mazdoor/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Firebase Cloud Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.requestPermission();
  messaging.subscribeToTopic(
      "service_requests"); // Subscribe to notifications for service requests

  messaging.getToken().then((token) {
    // Save the token to Firestore or your backend for later use (sending notifications)
    print("FCM Token: $token");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle notification when the app is in the foreground
    print("Notification received: ${message.notification?.title}");
    // You can display a local notification or update the UI here
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mazdoor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
