import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final fontWeight;
  final color;


  const CustomButton({
    super.key,
    required this.label,   // обязательно
    this.onTap, // необязательно
    this.fontWeight = FontWeight.w600,// необязательно
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap, // может быть null
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          shape: const RoundedRectangleBorder(),
          backgroundColor: Colors.white,
          foregroundColor: color,
        ),
        child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SF Pro Display',
              fontWeight: fontWeight,
              color: color,
          ),

        ),
      ),
    );
  }
}
