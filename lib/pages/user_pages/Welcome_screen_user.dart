import 'package:flutter/material.dart';
import 'package:last_telemedicine/pages/legacy/home_page.dart';
import 'package:last_telemedicine/pages/legacy/login_page.dart';

import 'package:last_telemedicine/auth/login_or_register.dart';

import '../../themes/AppColors.dart';

class WelcomeScreenUser extends StatelessWidget {
  const WelcomeScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 85),

              // Заголовок
              const Text(
                "Добрый день!",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 40),

              // Иконка пользователя
              Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      size: 120,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Георгий",
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                ],
              ),

              const Spacer(),

              // Кнопка Пациент
              SizedBox(
                width: 390,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.additionalAccent,
                    foregroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginOrRegister(),
                      ),
                    );
                  },
                  child: const Text(
                    "Найти своего врача",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
