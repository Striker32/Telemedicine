import 'package:flutter/material.dart';

import '../themes/AppColors.dart';

/// Текстовая красная кнопка "Назад" для использования в AppBar.leading.
/// По умолчанию вызывает Navigator.maybePop(context), но можно передать onTap.
class AppBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;

  const AppBarButton({
    Key? key,
    this.onTap,
    this.label = 'Назад',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap ?? () => Navigator.maybePop(context), // че при нажатии делать, по умолчанию "Назад"
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 4.0), // отступ сделать
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        softWrap: false, // запрет переноса
        style: const TextStyle(
          fontFamily: 'SF Pro Display', // подключи шрифт в pubspec.yaml
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}
