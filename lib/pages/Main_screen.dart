import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(right: 110),
                    child: SvgPicture.asset(
                      "assets/images/app/MedConnectText.svg",
                      fit: BoxFit.cover,
                      width: 100, // Растягиваем на всю ширину
                      height: 35, // Растягиваем на всю высоту
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
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
                  ),

                  const SizedBox(height: 25),

                  // Кнопка Врач
                  SizedBox(
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
                        // TODO: переход к экрану врача
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

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
