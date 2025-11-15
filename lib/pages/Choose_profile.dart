import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/pages/doctor_pages/login_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/register_user.dart';

import '../themes/AppColors.dart';

class ChooseProfile extends StatelessWidget {
  const ChooseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Верхняя часть — заголовок и иконка по центру
            Column(
              children: [
                const SizedBox(height: 120),
                const Center(
                  child: Text(
                    "Выберите профиль",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontFamily: "SF Pro Display",
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/icons/userProfile-hello.svg",
                    width: 120,
                    height: 120,
                  ),
                ),
              ],
            ),

            // Нижняя часть — кнопки по центру и прижаты к низу
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentRed,
                        foregroundColor: AppColors.mainColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPageUser(),
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
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background3,
                        foregroundColor: AppColors.primaryText,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPageDoctor(),
                          ),
                        );
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
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
