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
                  title: "Резкая боль в верхнем резце при еде",
                  name: "Александр",
                  surname: "Кузьмин",
                  datetime: "18.05.2025 15:10",
                  doctor: "Стоматолог",
                  description:
                  "Последние несколько дней появляется острая боль в верхнем резце при накусывании и при попадании холодной пищи. Боль периодическая, иногда пульсирующая, обезболивающие помогают слабо. Хотелось бы пройти осмотр стоматолога, возможно потребуется рентген и лечение каналов или реставрация зуба.",
                  city: "Санкт-Петербург",
                  cost: 7900,
                  urgent: true,
                ),

                ApplicationCard(
                  title: "Консультация по установке керамических брекетов",
                  name: "Мария",
                  surname: "Семенова",
                  datetime: "19.05.2025 11:30",
                  doctor: "Ортодонт",
                  description:
                  "Интересует установка керамических брекетов, хочу узнать о стоимости, сроках лечения и возможных ограничениях. Также хочу понять, какой уход потребуется во время лечения и насколько это будет комфортно для повседневной жизни. Планирую начать лечение в ближайшие месяцы и хочу получить подробную консультацию.",
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
