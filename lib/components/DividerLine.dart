import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  final double lenght;
  final Color colorDivider;

  const DividerLine({
    Key? key,
    this.lenght = 1.0,
    this.colorDivider = const Color(0x3C3C43),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: lenght),
      child: Divider(
        height: 2,
        color: colorDivider,
      ),
    );
  }
}