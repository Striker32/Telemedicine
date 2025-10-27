import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_telemedicine/components/AvatarWithPicker.dart';
import 'package:last_telemedicine/components/SettingsRow.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../../components/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/AppBarButton.dart';
import '../../themes/AppColors.dart';

class ChangePageUser extends StatefulWidget {
  const ChangePageUser({Key? key}) : super(key: key);

  @override
  State<ChangePageUser> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ChangePageUser> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kTitleColor = Color(0xFF111111); // цвет "Профиль"
  static const Color kLinkColor = Colors.red; // цвет "Настройки" и "Изменить"
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных
  static const Color kDivider = Color(0x3C3C43); // цвет разделителя

  final TextEditingController _phoneController = TextEditingController(
    text: '+ 7 900 502 93',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'example@mail.ru',
  );

  final TextEditingController _nameController = TextEditingController(
    text: 'Георгий',
  );

  final TextEditingController _surnameController = TextEditingController();

  String _currentCity = 'Санкт-Петербург';

  void _changeCityFuncion() async {
    // Пример: открыть страницу выбора языка и ждать результата
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ChangeCityPage(selected: _currentCity)),
    );
    if (result != null && result != _currentCity) {
      setState(() => _currentCity = result);
      // Здесь можно вызвать сохранение в настройки/сервер
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(),
        action: AppBarButton(label: 'Готово', onTap: () {}),
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
                    AvatarWithPicker(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryText,
                            ),
                          ),

                          DividerLine(),

                          TextField(
                            controller: _surnameController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: 'Фамилия',
                              hintStyle: TextStyle(
                                color: AppColors.addLightText,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryText,
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

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Введите свое имя и добавьте по желанию'
                '\nфотографию профиля',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF677076),
                ),
              ),
            ),

            const SizedBox(height: 40),

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

            // // Поля информации — без иконок, с тонкими разделителями
            // Inputfield(
            //   title: 'Сменить номер',
            //   value: '+7 900 502 9229',
            //   controller: _phoneController,
            // ),
            //
            //
            // const DividerLine(),
            //
            // Inputfield(
            //   title: 'Сменить почту',
            //   value: 'example@mail.ru',
            //   controller: _emailController,
            // ),
            // const DividerLine(),
            DividerLine(),

            SettingsRow(
              title: 'Сменить номер',
              titleColor: AppColors.addLightText,
              controller: _phoneController,
            ),

            DividerLine(),

            SettingsRow(
              title: 'Сменить почту',
              titleColor: AppColors.addLightText,
              controller: _emailController,
            ),

            DividerLine(),

            SettingsRow(
              title: _currentCity,
              titleColor: AppColors.addLightText,
              showArrow: true,
              onTap: _changeCityFuncion,
            ),

            const DividerLine(),

            const SizedBox(height: 20),

            // Кнопки действий
            Column(
              children: [
                const DividerLine(),

                CustomButton(
                  label: 'Изменить пароль',
                  color: Colors.red.shade200,
                ),

                const DividerLine(),

                const SizedBox(height: 12),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
