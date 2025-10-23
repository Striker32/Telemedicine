import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String title;
  final String value;
  final Color colorText;

  const InfoField({
    Key? key,
    required this.title,
    required this.value,
    this.colorText = const Color(0xFF9BA1A5),

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   // TODO: действие по тапу поля (если требуется)
      // },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: colorText,

                ),
              ),
            ],
          ),

      ),
    );
  }
}