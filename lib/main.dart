import 'package:firebase_core/firebase_core.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';
import 'package:last_telemedicine/pages/user_pages/login_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_gate.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/firebase_options.dart';
import 'package:last_telemedicine/pages/login_page.dart';
import 'package:last_telemedicine/themes/main_mode.dart';

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
        home: ProfilePage(),
        theme: lightMode,
    );
  }

}