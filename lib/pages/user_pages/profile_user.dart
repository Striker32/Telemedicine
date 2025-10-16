import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';

import '../../components/DividerLine.dart';
import '../../components/Infofield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kTitleColor = Color(0xFF111111); // цвет "Профиль"
  static const Color kLinkColor = Colors.red; // цвет "Настройки" и "Изменить"
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(0xFF9BA1A5); // цвет значения в контактных данных
  static const Color kDivider = Color(0x3C3C43); // цвет разделителя

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Верхняя панель: Настройки | Профиль | Изменить
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: открыть настройки
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kLinkColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Настройки',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: режим редактирования профиля
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kLinkColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Изменить',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),


            // Блок аватара, имени и телефона
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                  top: BorderSide(color: Colors.black12, width: 1),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFE0E0E6),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                      // Для реальной аватарки: backgroundImage: AssetImage(...) / NetworkImage(...)
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Георгий',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryText
                            ),
                          ),
                          Text(
                            '+7 900 502 9229',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: kSecondaryText
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Заголовок "Контактные данные"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Контактные данные',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF677076)),
              ),
            ),

            const SizedBox(height: 8),


            // Поля информации — без иконок, с тонкими разделителями

            const InfoField(
                title: 'Номер телефона',
                value: '+7 900 502 9229'
            ),

            const DividerLine(),

            const InfoField(
                title: 'Почта',
                value: 'example@mail.ru',

            ),

            const DividerLine(),

            const InfoField(
                title: 'Город',
                value: 'Санкт-Петербург',
            ),

            const DividerLine(),

            const SizedBox(height: 20),

            const DividerLine(),

            // Кнопки действий
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  CustomButton(
                    label: 'Изменить пароль',
                    color: Colors.red.shade200,
                  ),

                  const DividerLine(),


                  const SizedBox(height: 12),


                  const DividerLine(),

                  const CustomButton(
                    label: 'Выйти',
                    color: Colors.red,
                  ),

                  const DividerLine(),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
