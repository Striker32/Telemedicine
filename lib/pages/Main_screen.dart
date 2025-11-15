import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';

import '../themes/AppColors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/app/MainPageBackground.png",
          ), // 2. Указываем путь к картинке
          fit: BoxFit.cover, // 3. Растягиваем картинку на весь экран
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // всё уходит вниз
              crossAxisAlignment:
                  CrossAxisAlignment.start, // прижимаем к левому краю
              children: [
                // Логотип
                SvgPicture.asset(
                  "assets/images/app/MedConnectText.svg",
                  width: 237,
                  height: 30,
                ),

                const SizedBox(height: 15),

                // Текст
                Text(
                  "Наше приложение поможет быстро найти "
                  "\nнужного врача: в вашем городе или из любого"
                  "\nрегиона России — онлайн или на приёме.",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: "SF Pro Display",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 20),

                // Кнопка по центру
                Center(
                  child: SizedBox(
                    width: 390,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseProfile(),
                          ),
                        );
                      },
                      child: const Text(
                        "Начать",
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 20,
                          fontFamily: "SF Pro Display",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
