import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_telemedicine/components/Avatar/AvatarWithPicker.dart';
import 'package:last_telemedicine/components/SettingsRow.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../../auth/auth_service.dart';
import '../../components/Appbar/ProfileAppBar.dart';
import '../../components/Avatar/DisplayAvatar.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../themes/AppColors.dart';
import '../Choose_profile.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  State<ProfilePageUser> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageUser> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени

  bool _isEditing = false;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadDefaultAvatar();
  }

  Future<void> _loadDefaultAvatar() async {
    final byteData = await rootBundle.load('assets/images/app/userProfile.png');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/userProfile.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setState(() {
      _selectedImage = file;
    });
  }

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

  void logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: ProfileAppBar( // <-- 3. Используйте новый виджет
        title: 'Профиль',
        isEditing: _isEditing,
        onEdit: () {
          setState(() {
            _isEditing = true;
          });
        },
        onCancel: () {
          setState(() {
            _isEditing = false;
            // Можно добавить логику сброса изменений
          });
        },
        onDone: () {
          setState(() {
            _isEditing = false;
            // Логика сохранения
          });
        },
        onSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileSettingsPageUser(),
            ),
          );
        },
      ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Блок аватара, имени и телефона
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(color: AppColors.dividerLine, width: 1),
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                _isEditing
                                    ? AvatarWithPicker(
                                  initialImage: _selectedImage,
                                  onImageSelected: (file) {
                                    setState(() {
                                      _selectedImage = file;
                                    });
                                  },
                                )
                                    : DisplayAvatar(image: _selectedImage),

                            const SizedBox(width: 15),
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
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: _isEditing ? 16 : 20,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryText,
                                        ),
                                      ),

                                      if (_isEditing) ...[
                                        SizedBox(height: 6),
                                        DividerLine(),
                                        SizedBox(height: 6),
                                      ],

                                      TextField(
                                        controller: _surnameController,
                                        readOnly: !_isEditing,
                                        textAlign: TextAlign.start,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          visualDensity: VisualDensity.compact,
                                          hintText: 'Фамилия',
                                          hintStyle: TextStyle(
                                            color: AppColors.addLightText,
                                          ),
                                        ),
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: _isEditing ? 16 : 20,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.addLightText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (_isEditing)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Введите свое имя и добавьте по желанию\nфотографию профиля',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF677076),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),

                        // Заголовок "Контактные данные"
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Контактные данные',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF677076),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const DividerLine(),

                        DividerLine(),

                        SettingsRow(
                          viewTitle: 'Номер телефона',
                          editTitle: 'Сменить Телефон' ,
                          controller: _phoneController,
                          isEditable: _isEditing,
                        ),

                        DividerLine(),

                        SettingsRow(
                          viewTitle: 'Почта',
                          editTitle: 'Сменить почту' ,
                          controller: _emailController,
                          isEditable: _isEditing,
                        ),

                        DividerLine(),

                        SettingsRow(
                          viewTitle: "Город",
                          editTitle: "Изменить город",
                          value: _currentCity,
                          onTap: _isEditing ? _changeCityFuncion : null,
                          isEditable: _isEditing,
                        ),

                        const DividerLine(),

                        const SizedBox(height: 30),

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
                              const SizedBox(height: 30),

                              const DividerLine(),

                              CustomButton(
                                onTap: () { logout();},
                                label: 'Выйти',
                                color: AppColors.mainColor,
                              ),

                              const DividerLine(),
                            ],
                          ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}
