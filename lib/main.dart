import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:last_telemedicine/auth/auth_service.dart';
import 'package:last_telemedicine/pages/Chat.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';
import 'package:last_telemedicine/pages/Main_screen.dart';
import 'package:last_telemedicine/pages/News_feed.dart';
import 'package:last_telemedicine/pages/doctor_pages/applications_doctor.dart';
import 'package:last_telemedicine/pages/doctor_pages/profile_doctor.dart';
import 'package:last_telemedicine/pages/legacy/home_page.dart';
import 'package:last_telemedicine/pages/user_pages/Welcome_screen_user.dart';
import 'package:last_telemedicine/pages/user_pages/login_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';
import 'package:last_telemedicine/pages/user_pages/applications_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:last_telemedicine/themes/AppColors.dart';
import 'package:last_telemedicine/themes/TelemedicineTheme.dart';
import 'Services/Bottom_Navigator.dart';
import 'Services/Notification/NotificationService.dart';
import 'components/SplashScreen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_gate.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/firebase_options.dart';
import 'package:last_telemedicine/pages/legacy/login_page.dart';
import 'package:last_telemedicine/themes/legacy/main_mode.dart';

// Страницы доктора
import 'package:last_telemedicine/pages/doctor_pages/main_doctor.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //final notificationService = NotificationService();
  //await notificationService.initFCM();
  //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  await NotificationService().initialize(navigatorKey);

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "SF Pro Display",
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.mainColor,
        ),
      ),
      home: SplashScreen(),
    );
  }
}


// Future <void> handleBackgroundMessage(RemoteMessage message) async {
// // if app closed, background
// print('Message: ${message.notification?.title}');
// }
