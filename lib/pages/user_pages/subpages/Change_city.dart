import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/CustomAppBar.dart';
import 'package:last_telemedicine/components/DividerLine.dart';

import '../../../components/AppBarButton.dart';
import '../../../themes/AppColors.dart';


class ChangeCityPage extends StatelessWidget {
  final String? selected;

  const ChangeCityPage({Key? key, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> cities = [
      "Архангельск",
      "Вельск",
      "Волгоград",
      "Воронеж",
      "Екатеринбург",
      "Иваново",
      "Казань",
      "Каргополь",
      "Коряжма",
      "Котлас",
      "Красноярск",
      "Москва",
      "Мезень",
      "Мирный",
      "Нижний Новгород",
      "Новодвинск",
      "Новосибирск",
      "Няндома",
      "Онега",
      "Омск",
      "Пермь",
      "Ростов-на-Дону",
      "Самара",
      "Санкт-Петербург",
      "Северодвинск",
      "Тюмень",
      "Уфа",
      "Шенкурск",
      "Ярославль",
    ];
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(label: 'Назад', onTap: () {}),
        action: AppBarButton(label: '', onTap: () {}),
      ),
      body: ListView.separated(
        itemCount: cities.length,
        separatorBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(left: 15),
          child: const DividerLine(),
        ),
        itemBuilder: (context, index) {
          final lang = cities[index];
          final isSelected = lang == selected;
          return Container(
            color: AppColors.white, // ← фон карточки
            child: ListTile(
              title: Text(lang),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primaryBlue)
                  : null,
              onTap: () => Navigator.pop(context, lang),
            ),
          );
        },
      ),
    );
  }
}