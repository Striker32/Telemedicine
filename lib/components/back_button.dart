import 'package:flutter/material.dart';

class BackButtonRed extends StatelessWidget {
  final VoidCallback? onTap;

  const BackButtonRed({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft, // всегда слева сверху
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, // удобнее нажимать
            onTap: onTap ?? () => Navigator.maybePop(context),
            child: const Text(
              'Назад',
              style: TextStyle(
                fontFamily: 'SF Pro Display', // если подключил шрифт
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
