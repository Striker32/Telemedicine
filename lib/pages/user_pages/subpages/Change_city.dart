import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Выберите город')),
      body: ListView.separated(
        itemCount: cities.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final lang = cities[index];
          final isSelected = lang == selected;
          return ListTile(
            title: Text(lang),
            trailing: isSelected
                ? const Icon(Icons.check, color: AppColors.primaryBlue)
                : null,
            onTap: () => Navigator.pop(context, lang),
          );
        },
      ),
    );
  }
}