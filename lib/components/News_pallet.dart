import 'package:flutter/material.dart';

import '../themes/AppColors.dart';

class NewsCard extends StatelessWidget {
  final String date; // например "9 февраля 2025 15:45"
  final String title; // белый текст слева снизу
  final ImageProvider? image; // фон (FileImage/NetworkImage/AssetImage)
  final VoidCallback? onRead; // действие по нажатию "Читать"
  final double height;
  final BorderRadiusGeometry borderRadius;

  const NewsCard({
    Key? key,
    required this.date,
    required this.title,
    this.image,
    this.onRead,
    this.height = 240,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Фон: изображение или плейсхолдер
            if (image != null)
              Image(
                image: image!,
                fit: BoxFit.cover,
              )
            else
              Container(color: Colors.grey.shade300),

            // Затемнение поверх изображения
            Container(color: Colors.black.withOpacity(0.45)),

            // Содержимое: дата вверху слева, заголовок снизу слева, "Читать" справа внизу
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  // Дата сверху слева
                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0x80F5F5F7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Низ: заголовок слева и кнопка справа
                  Row(

                    children: [
                      // Заголовок (может занимать несколько строк)
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Кнопка "Читать"
                      GestureDetector(
                        onTap: onRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Читать',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
