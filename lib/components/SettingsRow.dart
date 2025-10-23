// // ТРИ РАЗНЫХ ВИДЖЕТА
// Inputfield(
// title: 'Сменить номер',
// controller: _phoneController,
// ),
// Inputfield(
// title: 'Сменить почту',
// controller: _emailController,
// ),
// SettingsTile(
// title: 'Сменить город',
// trailing: Text(_currentCity),
// onTap: _changeCityFuncion,
// ),


import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final String title;
  final String? value; // Для отображения значения (как в InfoField)
  final TextEditingController? controller; // Для редактирования (как в InputField)
  final VoidCallback? onTap; // Для действия по нажатию (как в SettingsTileField)
  final Widget? trailing; // Для кастомных элементов в конце, например, иконки или переключателя
  final bool showArrow; // Показывать ли стрелку "вперед"
  final Color titleColor;

  const SettingsRow({
    Key? key,
    required this.title,
    this.value,
    this.controller,
    this.onTap,
    this.trailing,
    this.showArrow = false,
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Проверка, чтобы не передать взаимоисключающие параметры
    assert(value == null ||
        controller == null, 'Cannot provide both a value and a controller.');
    assert(onTap == null ||
        controller == null, 'Cannot have a text field in a tappable row.');

    // Определение, какой виджет будет в правой части
    Widget _buildTrailingWidget() {
      if (trailing != null) {
        return trailing!;
      }
      if (controller != null) {
        return Expanded(
          child: TextField(
            controller: controller,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        );
      }
      if (value != null) {
        return Text(value!, style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400
        ));
      }
      if (showArrow) {
        return Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey);
      }
      return const SizedBox.shrink(); // Ничего, если не задано
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: titleColor)),
            const SizedBox(width: 16),
            // Гибкая правая часть
            _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }
}