import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/login_or_register.dart';
import 'package:last_telemedicine/components/home_page.dart';

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
              return const HomePage();
            }

            // user is NOT loggen in

            else {
              return const LoginOrRegister();
            }

          }
      ),
    );
  }
}
 
