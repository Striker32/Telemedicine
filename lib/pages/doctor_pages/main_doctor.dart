import 'package:flutter/material.dart';
import '../../components/CustomAppBar.dart';
import '../../components/AppBarButton.dart';
import '../../components/Application_for_feed.dart';
import '../user_pages/subpages/Change_city.dart';

class MainDoctor extends StatelessWidget {
  const MainDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF4),
      appBar: CustomAppBar(
        titleText: 'Лента',
        leading: AppBarButton(label: '', onTap: () {}),
        action: AppBarButton(label: 'Локация', onTap: () async {
          final selectedCity = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeCityPage(selected: ''),
            ),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Все объявления",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 0),

            // Кнопка "Создать заявку" с вызовом popup
            // GestureDetector(...),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 2),
              children: const [
                ApplicationCard(
                  title: "Стреляющая боль бокового верхнего резца",
                  name: "Георгий",
                  surname: "Медников",
                  datetime: "23.03.2025 16:48",
                  doctor: "Стоматолог",
                  description:
                  "Несколько дней мучает зубная боль. Сначала реагировал только на холодное и горячее, а сейчас болит постоянно и иногда отдаёт пульсирующей болью. Обезболивающие почти не помогают. Нужна консультация стоматолога, чтобы разобраться в причине и начать лечение",
                  city: "Санкт-Петербург",
                  cost: 8000,
                  urgent: true,
                ),
                ApplicationCard(
                  title: "Консультация по брекетам",
                  name: "Анна",
                  surname: "Кононова",
                  datetime: "24.03.2025 10:15",
                  doctor: "Ортодонт",
                  description: "Хотела бы узнать про установку брекетов. Плачу натурой.",
                  city: "Москва",
                  cost: 0,
                  urgent: false,
                  hasResponded: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
