import 'package:flutter/material.dart';
import '../themes/AppColors.dart';

class DividerLine extends StatelessWidget {
  final double length; // ← поправил опечатку: lenght → length
  final Color color;
  final double thickness;

  const DividerLine({
    Key? key,
    this.length = 0.0,
    this.thickness = 1.0,
    this.color = AppColors.greyDivider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: length),
      child: Container(
        height: thickness,
        color: color,
      ),
    );
  }
}
