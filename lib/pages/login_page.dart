import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_service.dart';
import 'package:last_telemedicine/components/My_button.dart';
import 'package:last_telemedicine/components/back_button.dart';
import 'package:last_telemedicine/components/my_textfield.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';

class LoginPage extends StatelessWidget {

  // email and px text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to go on register page
  void Function()? onTap;

  LoginPage ({
    super.key,
    required this.onTap,
  });

  //login method
  void login(BuildContext context) async {
    // caught auth service
    final authService = AuthService();


    // DEBUG, DELETE
    final email = _emailController.text;
    final pass = _pwController.text;
    debugPrint('DEBUG: email="$email", pass length=${pass.length}');

    // try login
    try {
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text,);
    }

    // catch errors
    catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false, // убираем стандартные рамки
          titleSpacing: 0, // убираем отступы слева
          title: Align(
            alignment: Alignment.centerLeft,
            child: AppBarBackButton(),
          ),
        ),
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // logo
            Icon(
              Icons.message,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),

            // welcome back
            const SizedBox(height: 25),
            Text(
              "Welcome back, you've benn missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            MytextField(
              hintText: "Email",
              obscuretext: false,
              controller: _emailController,
            ),

            // password textfield
            const SizedBox(height: 10),
            MytextField(
              hintText: "Password",
              obscuretext: true,
              controller: _pwController,
            ),

            // login button
            const SizedBox(height: 25),

            // register button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),

            // text to register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Register now",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            // Кнопка НАЗАД
          ],
        ),
      )

    );

  }

}