import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/upload_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// void main() {
//   runApp(const AIStudyBuddyApp());
// }
void main() async {
  // Must be called before Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AIStudyBuddyApp());
}
Future<void> setupFCM() async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  final token = await messaging.getToken();

  // Save token to Firestore so backend can send you notifications
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && token != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );
  }

  FirebaseMessaging.onMessage.listen((message) {
    debugPrint('Notification: ${message.notification?.title}');
    // show a local banner/snackbar here if app is in foreground
  });
}
class AIStudyBuddyApp extends StatelessWidget {
  const AIStudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: FirebaseAuth.instance.currentUser != null
    ? HomeScreen()
        :  LoginScreen(),
    );
  }
}
