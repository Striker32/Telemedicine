import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/legacy/My_button.dart';
import 'package:last_telemedicine/components/legacy/my_textfield.dart';

import '../components/back_button.dart';

class RegisterPage extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmpwController = TextEditingController();

  // tap to go on login page
  void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  // register method

void register() {
  //
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
                "Create account",
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

              const SizedBox(height: 10),
              // confirm button
              MytextField(
                hintText: "Confirm Password",
                obscuretext: true,
                controller: _confirmpwController,
              ),

              const SizedBox(height: 25),

              // register suggestion
              MyButton(
                text: "Register",
                onTap: register,
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Login now",
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