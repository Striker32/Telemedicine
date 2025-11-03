import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/pages/Main_screen.dart';
import 'package:last_telemedicine/pages/legacy/home_page.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';

import '../Services/Bottom_Navigator.dart';
import '../pages/Choose_profile.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    String userEmail = 'a@a.com';

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {

            final email = snapshot.data!.email ?? '';
            final domain = email.split('@').last;

            // debugPrint('DEBUG FULL EMAIL: email="${userEmail}"');
            if (domain == "doctor.com") {
              return const BottomNavigator(usertype: "doctor");
            } else if (domain == "user.com") {
              return const BottomNavigator(usertype: "user");
            } else {
              return const ChooseProfile();
            }
          }
          // user is NOT loggen in
          else {
            return const MainScreen();
          }
        },
      ),
    );
  }
}
