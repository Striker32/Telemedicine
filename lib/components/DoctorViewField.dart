import 'package:flutter/material.dart';
import 'package:last_telemedicine/themes/AppColors.dart';

class FieldDoctorView extends StatelessWidget {
  final String title; // верхний текст (например "Keep in touch")
  final String mainText; // основной текст (например телефон)
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? mainStyle;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final bool aboutself;

  const FieldDoctorView({
    Key? key,
    required this.title,
    required this.mainText,
    this.onTap,
    this.titleStyle,
    this.mainStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    this.alignment = Alignment.centerLeft,
    this.aboutself = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = TextStyle(
      height: 1.2,
      color: AppColors.primaryText,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
    final defaultMainStyle = const TextStyle(
      height: 1.3,
      color: AppColors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle ?? defaultTitleStyle),
        const SizedBox(height: 4),
        (aboutself == true)
            ? Container(
                padding: const EdgeInsets.only(
                  right: 8,
                  top: 10,
                  bottom: 15,
                  left: 12,
                ),
                color: AppColors.foregroundUSELED,
                child: Text(mainText, style: mainStyle ?? defaultMainStyle),
              )
            : Text(mainText, style: mainStyle ?? defaultMainStyle),
      ],
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: onTap == null
            ? content
            : InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: onTap,
                child: content,
              ),
      ),
    );
  }
}
