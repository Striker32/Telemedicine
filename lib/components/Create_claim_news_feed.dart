import 'package:flutter/material.dart';

import '../themes/AppColors.dart';

class CreateRequestButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color color;
  final double iconSize;
  final double circleSize;
  final TextStyle? labelStyle;

  const CreateRequestButton({
    Key? key,
    required this.onTap,
    this.label = 'Создать заявку',
    this.color = AppColors.mainColor,
    this.iconSize = 20,
    this.circleSize = 26,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // можно подогнать под макет
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.add, color: Colors.white, size: iconSize),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              style: labelStyle ??
                  const TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

}
