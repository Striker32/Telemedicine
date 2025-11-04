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

import '../themes/AppColors.dart';

class SettingsRow extends StatelessWidget {
  final String viewTitle;
  final String? editTitle;
  final String? value; // Для отображения значения (как в InfoField)
  final TextEditingController? controller; // Для редактирования (как в InputField)
  final VoidCallback? onTap; // Для действия по нажатию (как в SettingsTileField)
  final Widget? trailing; // Для кастомных элементов в конце, например, иконки или переключателя
  final bool showArrow; // Показывать ли стрелку "вперед"
  final bool isEditable;

  const SettingsRow({
    Key? key,
    required this.viewTitle,
    this.editTitle,
    this.value,
    this.controller,
    this.onTap,
    this.trailing,
    this.showArrow = false,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String currentTitle = (isEditable && editTitle != null) ? editTitle! : viewTitle;

  // Цвет заголовка
    final Color titleColor = isEditable ? AppColors.addLightText : AppColors.primaryText;

  // Цвет поля ввода
    final Color controllerColor = isEditable ? AppColors.primaryText : AppColors.addLightText;


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
            readOnly: !isEditable,
            textAlign: TextAlign.end,
            style: TextStyle(color: controllerColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        );
      }
      if (value != null) {
        return Text(value!, style: TextStyle(
            color: isEditable ? AppColors.primaryText : AppColors.addLightText,
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
            Text(currentTitle, style: TextStyle(fontSize: 16, color: titleColor)),
            const SizedBox(width: 16),
            // Гибкая правая часть
            _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }
}