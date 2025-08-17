import 'package:flutter/material.dart';
import 'package:flutter_medicine/pages/login_page.dart';
import 'package:flutter_medicine/themes/main_mode.dart';

void main() => runApp(Myapp());


class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: LoginPage(),
        theme: lightMode,
    );
  }

}