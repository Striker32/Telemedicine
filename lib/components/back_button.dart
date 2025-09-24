import 'package:flutter/material.dart';

/// Текстовая красная кнопка "Назад" для использования в AppBar.leading.
/// По умолчанию вызывает Navigator.maybePop(context), но можно передать onTap.
class AppBarBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;

  const AppBarBackButton({
    Key? key,
    this.onTap,
    this.label = 'Назад',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextButton(
        onPressed: onTap ?? () => Navigator.maybePop(context), // че при нажатии делать
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          softWrap: false, // запрет переноса
          style: const TextStyle(
            fontFamily: 'SF Pro Display', // подключи шрифт в pubspec.yaml
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
