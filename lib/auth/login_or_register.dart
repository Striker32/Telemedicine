import 'package:flutter/material.dart';
import 'package:last_telemedicine/pages/legacy/login_page.dart';
import 'package:last_telemedicine/pages/legacy/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override

  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }

  Widget build(BuildContext context) {
    if (showLoginPage == true) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
