import 'package:flutter/material.dart';
import 'package:last_telemedicine/themes/AppColors.dart';

// Наш универсальный AppBar, который реализует PreferredSizeWidget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  // кнопка слева. Виджетом
  final Widget? leading;
  // Заголовок посередине. текстом
  final String? titleText;
  // кнопка справа. Виджетом
  final Widget? action;
  // Цвет фона
  final Color backgroundColor;
  // Тень. Мб убрать
  final double elevation;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.titleText,
    this.action,
    this.backgroundColor = AppColors.background,
    this.elevation = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(0.5),

      // 1. Используем Stack для идеального центрирования
      title: Stack(
        // Позволяем Stack'у рисовать элементы по всей ширине AppBar
        children: [
          // 2. Левый виджет (кнопка "назад")
          if (leading != null)
            Align(
              alignment: Alignment.centerLeft,
              child: leading,
            ),

          // 3. Центральный виджет (заголовок)
          if (titleText != null)
            Align(
              alignment: Alignment.center,
              child: Text(
                titleText!,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // 4. Правый виджет (кнопка "готово")
          if (action != null)
            Align(
              alignment: Alignment.centerRight,
              child: action,
            ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
