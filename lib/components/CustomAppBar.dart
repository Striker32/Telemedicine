import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
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
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(0.5),
      centerTitle: true,

      title: Stack(
        children: [
          if (leading != null)
            Align(
              alignment: Alignment.centerLeft,
              child: leading,
            ),
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
          if (action != null)
            Align(
              alignment: Alignment.centerRight,
              child: action,
            ),
        ],
      ),

      // 👇 вот тут добавляется DividerLine
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: DividerLine(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
