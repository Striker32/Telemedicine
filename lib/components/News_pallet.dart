import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/Notification.dart';
import 'package:last_telemedicine/themes/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final String date;
  final String title;
  final String url;
  final String imagePath;

  const NewsCard({
    Key? key,
    required this.date,
    required this.title,
    required this.url,
    required this.imagePath,
  }) : super(key: key);

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // можно показать Snackbar или лог
      showCustomNotification(context, "Не удалось открыть ссылку");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 210,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Фоновое изображение растянутое по границам блока
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Color(0xFFA8A7A7),
                                fontSize: 12,
                                height: 1.3,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: AppColors.background3,
                                fontSize: 16,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 50),

                      Opacity(
                        opacity: 0.66,
                        child: GestureDetector(
                          onTap: () => _openUrl(context),
                          child: Container(
                            height: 33,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Читать',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
