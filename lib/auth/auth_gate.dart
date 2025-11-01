import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/pages/legacy/home_page.dart';

import '../Services/Bottom_Navigator.dart';
import '../pages/Choose_profile.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges() ,
          builder: (context, snapshot) {
            // user logged in
            if (snapshot.hasData) {
              return const BottomNavigator();
            }

            // user is NOT loggen in

            else {
              return const ChooseProfile();
            }

          }
      ),
    );
  }
}
 
