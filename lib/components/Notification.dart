import 'package:flutter/material.dart';
import '../themes/AppColors.dart';
import 'DividerLine.dart';

void showCustomNotification(BuildContext? context, String titleText) {
  if (context == null || !context.mounted) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromARGB(100, 0, 0, 0), // 30% черный
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryText,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

                const DividerLine(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Закрыть',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
