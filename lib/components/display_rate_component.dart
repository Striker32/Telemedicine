import 'package:flutter/material.dart';

import '../themes/AppColors.dart';

class RatingBadge extends StatelessWidget {
  final String rating;
  final String subtitle;
  final Color badgeColor;
  final double badgeSize;
  final TextStyle? ratingStyle;
  final TextStyle? subtitleStyle;

  const RatingBadge({
    Key? key,
    required this.rating,
    required this.subtitle,
    this.badgeColor = Colors.red,
    this.badgeSize = 36,
    this.ratingStyle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(badgeSize / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            rating,
            style: ratingStyle ??
                TextStyle(
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: subtitleStyle ??
              const TextStyle(
                color: AppColors.addLightText,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
