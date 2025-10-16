import 'package:flutter/material.dart';
import 'package:last_telemedicine/pages/home_page.dart';
import 'package:last_telemedicine/pages/login_page.dart';

import 'package:last_telemedicine/auth/login_or_register.dart';

class ChooseProfile extends StatelessWidget {
  const ChooseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок
              const Text(
                "Выберите профиль",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 40),

              // Иконка пользователя
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 300),

              // Кнопка Пациент
              SizedBox(
                width: 370,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade50,
                    foregroundColor: Colors.redAccent,
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
                    "Пациент",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Кнопка Врач
              SizedBox(
                width: 370,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: переход к экрану врача
                  },
                  child: const Text(
                    "Врач",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
