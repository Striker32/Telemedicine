import 'package:flutter/material.dart';
import 'package:flutter_medicine/components/My_button.dart';
import 'package:flutter_medicine/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  // email and px text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  LoginPage ({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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
            // register suggestion
            MyButton()
          ],
        ),
      )

    );

  }

}