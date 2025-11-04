import 'package:flutter/material.dart';
import '../themes/AppColors.dart';
import 'DividerLine.dart';


Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String subtitle,
    String leftButtonText,
    String rightButtonText,
    ) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromARGB(77, 0, 0, 0),
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
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
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryText,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),

                const DividerLine(),

                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.center,
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            leftButtonText,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mainColor,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: AppColors.dividerLine,
                      ),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.center,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            rightButtonText,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainColor,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ) ?? false;
}
