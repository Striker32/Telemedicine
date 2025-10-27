import 'package:firebase_core/firebase_core.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';
import 'package:last_telemedicine/pages/Main_screen.dart';
import 'package:last_telemedicine/pages/News_feed.dart';
import 'package:last_telemedicine/pages/doctor_pages/applications_doctor.dart';
import 'package:last_telemedicine/pages/doctor_pages/profile_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/Welcome_screen_user.dart';
import 'package:last_telemedicine/pages/user_pages/login_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_change_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';
import 'package:last_telemedicine/pages/user_pages/applications_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:last_telemedicine/themes/TelemedicineTheme.dart';
import 'Services/Bottom_Navigator.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_gate.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/firebase_options.dart';
import 'package:last_telemedicine/pages/legacy/login_page.dart';
import 'package:last_telemedicine/themes/legacy/main_mode.dart';

// Страницы доктора
import 'package:last_telemedicine/pages/doctor_pages/main_doctor.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
        fontFamily: "SF Pro Display",
      ),
    );
  }

}