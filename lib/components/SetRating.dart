import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/auth/Fb_request_model.dart';
import '../themes/AppColors.dart';
import 'DividerLine.dart';

Future<bool> showRatingDialog({
  required BuildContext context,
  required String userID,
  required String doctorID,
  required String requestID,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color.fromARGB(100, 0, 0, 0),
        builder: (BuildContext context) {
          int rating = 0;
          String topTitle = 'Как справился врач?';
          // Тексты под звёздами по количеству оценок
          final Map<int, String> ratingTexts = {
            0: 'Как справился врач?',
            1: 'Врач справился очень плохо!',
            2: 'Врач справился плохо!',
            3: 'Врач справился нормально.',
            4: 'Врач справился хорошо!',
            5: 'Врач справился отлично!',
          };

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: StatefulBuilder(
                builder: (context, setState) {
                  void setRating(int value) {
                    setState(() {
                      rating = value;
                      topTitle = ratingTexts[rating] ?? topTitle;
                    });
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              Text(
                                'Можете оставить отзыв',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryText,
                                  decoration: TextDecoration.none,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ), // расстояние от верхней надписи до звёзд 20px

                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // горизонтальный центр
                                children: List.generate(5, (index) {
                                  final int starIndex = index + 1;
                                  final double opacity = (rating >= starIndex)
                                      ? 1.0
                                      : 0.1;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? 0 : 10,
                                    ), // между звёздами 10px
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => setRating(starIndex),
                                      child: Opacity(
                                        opacity: opacity,
                                        child: SizedBox(
                                          width: 26,
                                          height: 25,
                                          child: SvgPicture.asset(
                                            "assets/images/icons/rating_star.svg",
                                            width: 26,
                                            height: 25,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(
                                height: 10,
                              ), // расстояние после звёзд 10px

                              Text(
                                ratingTexts[rating]!,
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

                        const SizedBox(height: 20),

                        const DividerLine(),

                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pop(true), // Не хочу
                                  child: const Text(
                                    'Не хочу',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.mainColor,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Container(width: 1, color: AppColors.dividerLine),
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () async {
                                    if (rating == 0) {
                                      setState(() {
                                        topTitle = 'Сначала поставьте оценку';
                                      });
                                      return;
                                    }

                                    final sender =
                                        FirebaseAuth.instance.currentUser;
                                    if (sender != null) {
                                      final patch = {
                                        'status': '2',
                                        'rating': rating,
                                      };

                                      final repo = RequestRepository();

                                      await repo.updateRequest(
                                        requestID,
                                        patch,
                                        doctorUid: doctorID,
                                        rating: rating,
                                      );

                                      Navigator.of(context).pop(
                                        false,
                                      ); // Закрываем диалог после отправки
                                    }
                                  },
                                  child: const Text(
                                    'Отправить',
                                    style: TextStyle(
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
                  );
                },
              ),
            ),
          );
        },
      ) ??
      false;
}
