import 'package:firebase_core/firebase_core.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';
import 'package:last_telemedicine/pages/user_pages/login_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_change_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';
import 'package:last_telemedicine/themes/TelemedicineTheme.dart';
import 'Services/Bottom_Navigator.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_gate.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/firebase_options.dart';
import 'package:last_telemedicine/pages/login_page.dart';
import 'package:last_telemedicine/themes/legacy/main_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Myapp());
}

// ... (остальной код в main.dart)

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем базовую тему, чтобы на её основе сделать изменения
    final ThemeData baseTheme = ThemeData.light(); // Или ThemeData.dark()

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigator(),
      theme: appTheme,
    );
  }
}
