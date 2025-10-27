import 'package:flutter/material.dart';
import 'package:last_telemedicine/themes/AppColors.dart';

class DoctorRespondedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool enabled;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color accentColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double? height; // если задано — фиксированная высота кнопки
  final double minWidth; // минимальная ширина кнопки
  final double subtitleheight;

  const DoctorRespondedButton({
    Key? key,
    required this.onTap,
    this.enabled = true,
    this.title = 'Выбрать',
    this.subtitle = 'Врач откликнулся на Вашу заявку!',
    this.backgroundColor = const Color(0xFFFFF1F3),
    this.accentColor = const Color(0xFFE53935),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    this.height,
    this.minWidth = 120,
    this.subtitleheight = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = enabled ? onTap : null;
    final textOpacity = enabled ? 1.0 : 0.5;

    return Semantics(
      button: true,
      enabled: enabled,
      label: '$title. $subtitle',
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: effectiveOnTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidth,
              minHeight: height ?? 0,
              maxHeight: height ?? double.infinity,
            ),
            child: Container(
              height: height, // если null — высота определяется контентом + padding

              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/icons/bolt.png", height: subtitleheight),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: subtitleheight,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
