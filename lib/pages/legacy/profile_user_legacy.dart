import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/Choose_profile.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';

import '../../components/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/SettingsRow.dart';
import '../../components/AppBarButton.dart';
import '../../themes/AppColors.dart';

class LegacyProfilePageUser extends StatefulWidget {
  const LegacyProfilePageUser({Key? key}) : super(key: key);

  @override
  State<LegacyProfilePageUser> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<LegacyProfilePageUser> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      // AppBar
      appBar: CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(label: 'Настройки', onTap: () {
          Navigator.push(
            context, // 'context' здесь очень важен!
            MaterialPageRoute(builder: (context) => ProfileSettingsPageUser()), // Замените DoctorScreen() на ваш виджет
          );
        }),
        action: AppBarButton(label: 'Изменить', onTap: () {
          Navigator.push(
            context, // 'context' здесь очень важен!
            MaterialPageRoute(builder: (context) => ProfilePageUser()), // Замените DoctorScreen() на ваш виджет
          );
        }),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFE0E0E6),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
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
                              color: kPrimaryText,
                            ),
                          ),
                          Text(
                            '+7 900 502 9229',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kSecondaryText,
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
                  color: Color(0xFF677076),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const DividerLine(),

            // Поля информации — без иконок, с тонкими разделителями
            const SettingsRow(title: 'Номер телефона', value: '+7 900 502 9229'),

            const DividerLine(),

            const SettingsRow(title: 'Почта', value: 'example@mail.ru'),

            const DividerLine(),

            const SettingsRow(title: 'Город', value: 'Санкт-Петербург'),

            const DividerLine(),


            const SizedBox(height: 20),

            // Кнопки действий
            Column(
              children: [

                const DividerLine(),

                CustomButton(
                  label: 'Изменить пароль',
                  color: Colors.red.shade200,
                  onTap: (){},
                ),

                const DividerLine(),

                const SizedBox(height: 12),

                const DividerLine(),

                CustomButton(onTap: () {
                  Navigator.push(
                    context, // 'context' здесь очень важен!
                    MaterialPageRoute(builder: (context) => ChooseProfile()), // Замените DoctorScreen() на ваш виджет
                  );
                },label: 'Выйти', color: Colors.red),

                const DividerLine(height: 1.2,),

              ],
            ),


            const Spacer(),
          ],
        ),
      ),
    );
  }
}
