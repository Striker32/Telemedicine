import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_telemedicine/components/Avatar/AvatarWithPicker.dart';
import 'package:last_telemedicine/components/SettingsRow.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../../components/Avatar/DisplayAvatar.dart';
import '../../components/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/AppBarButton.dart';
import '../../themes/AppColors.dart';
import '../Choose_profile.dart';

class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  State<ProfilePageUser> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageUser> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kDivider = Color(0x3C3C43); // цвет разделителя

  bool _isEditing = false;

  File _selectedImage = File('assets/images/app/avatar.png');

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


  CustomAppBar _buildAppBar() {
    if (_isEditing) {
      // AppBar для режима редактирования
      return CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(
          label: 'Отмена',
          onTap: () {
            setState(() {
              _isEditing = false;
              // Здесь логика отмены изменений, если она нужна
            });
          },
        ),
        action: AppBarButton(
          label: 'Готово',
          onTap: () {
            // Логика сохранения данных
            setState(() {
              _isEditing = false;
            });
          },
        ),
      );
    } else {
      // AppBar для режима просмотра
      return CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(
          label: 'Настройки',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingsPageUser(),
              ),
            );
          },
        ),
        action: AppBarButton(
          label: 'Изменить',
          onTap: () {
            setState(() {
              _isEditing = true;
            });
          },
        ),
      );
    }
  }

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
      appBar: _buildAppBar(),
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
                    _isEditing
                        ? AvatarWithPicker(
                            initialImage:
                                _selectedImage, // Передаем текущее изображение
                            onImageSelected: (file) {
                              // Получаем выбранный файл обратно
                              setState(() {
                                _selectedImage = file;
                              });
                            },
                          )
                        : DisplayAvatar(image: _selectedImage),

                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            readOnly: !_isEditing,
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
                            readOnly: !_isEditing,
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

            const SizedBox(height: 8),

            if (_isEditing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Введите свое имя и добавьте по желанию\nфотографию профиля',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),

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

            DividerLine(),

            SettingsRow(
              title: 'Сменить номер',
              titleColor: AppColors.addLightText,
              controller: _phoneController,
              isEditable: _isEditing,
            ),

            DividerLine(),

            SettingsRow(
              title: 'Сменить почту',
              titleColor: AppColors.addLightText,
              controller: _emailController,
              isEditable: _isEditing,
            ),

            DividerLine(),

            SettingsRow(
              title: _currentCity,
              titleColor: AppColors.addLightText,
              showArrow: true,
              onTap: _isEditing ? _changeCityFuncion : null,
            ),

            const DividerLine(),

            const SizedBox(height: 24),

            // Кнопки действий
            Column(
              children: [
                const DividerLine(),

                CustomButton(
                  label: 'Изменить пароль',
                  color: Colors.red.shade200,
                ),

                const DividerLine(),

              ],
            ),

            if (!_isEditing)
              Column(
                children: [
                  const SizedBox(height: 24),

                  const DividerLine(),

                  CustomButton(
                    onTap: () {
                      Navigator.push(
                        context, // 'context' здесь очень важен!
                        MaterialPageRoute(
                          builder: (context) => ChooseProfile(),
                        ), // Замените DoctorScreen() на ваш виджет
                      );
                    },
                    label: 'Выйти',
                    color: Colors.red,
                  ),

                  const DividerLine(height: 1.2),
                ],
              ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
