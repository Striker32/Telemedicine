import 'package:flutter/material.dart';

import '../themes/AppColors.dart';

class DividerLine extends StatelessWidget {
  final double lenght;
  final Color colorDivider;
  final double height;
  const DividerLine({
    Key? key,
    this.lenght = 0.0,
    this.height = 1.0,
    this.colorDivider = AppColors.greyDivider,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: lenght),
      child: Divider(height: height, color: colorDivider),
    );
  }
}
