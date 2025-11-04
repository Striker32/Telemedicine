import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../auth/auth_service.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Appbar/ProfileAppBar.dart';
import '../../components/Avatar/AvatarWithPicker.dart';
import '../../components/Avatar/DisplayAvatar.dart';
import '../../components/DividerLine.dart';
import '../../components/Notification.dart';
import '../../components/SettingsRow.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../themes/AppColors.dart';
import '../user_pages/profile_settings_user.dart';
import '../user_pages/subpages/Change_city.dart';

class ProfilePageDoctor extends StatefulWidget {
  const ProfilePageDoctor({Key? key}) : super(key: key);

  @override
  State<ProfilePageDoctor> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageDoctor> {
  // Хранение данных для сброса изменений
  late String _initialName;
  late String _initialSurname;
  late String _initialPhone;
  late String _initialEmail;
  late String _initialCity;
  late File _initialAvatar;
  late String _initialSpecialization;
  late String _initialExperience;
  late String _initialPlaceOfWork;
  late String _initialPrice;
  late String _initialAbout;

  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных

  bool _isEditing = false;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadDefaultAvatar();
    _initialName = _nameController.text;
    _initialSurname = _surnameController.text;
    _initialPhone = _phoneController.text;
    _initialEmail = _emailController.text;
    _initialCity = _currentCity;

    _initialSpecialization = _specializationController.text;
    _initialExperience = _experienceController.text;
    _initialPlaceOfWork = _placeOfWorkController.text;
    _initialPrice = _priceController.text;
    _initialAbout = _aboutController.text;
  }

  Future<void> _loadDefaultAvatar() async {
    final byteData = await rootBundle.load('assets/images/app/userProfile.png');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/userProfile.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setState(() {
      _selectedImage = file;
      _initialAvatar = file; // ← сохраняем оригинал
    });
  }

  final TextEditingController _phoneController = TextEditingController(
    text: '+ 7 900 502 93',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'example@mail.ru',
  );

  final TextEditingController _nameController = TextEditingController(
    text: 'Мария Денисовна',
  );

  final TextEditingController _surnameController = TextEditingController(
    text: 'Речнекова',
  );

  final TextEditingController _specializationController = TextEditingController(
    text: 'Стоматолог',
  );

  final TextEditingController _experienceController = TextEditingController(
    text: '13 лет',
  );

  final TextEditingController _placeOfWorkController = TextEditingController(
    text: 'Городская больница №28',
  );

  final TextEditingController _priceController = TextEditingController(
    text: '3900 ₽',
  );

  final TextEditingController _aboutController = TextEditingController(
    text: 'Специализируюсь на лечении кариеса, пульпита, заболеваний дёсен,'
        ' а также проведении профессиональной гигиены полости рта'
        '  Помогаю пациентам сохранить здоровье зубов и красивую улыбку,'
        ' подбираю индивидуальный подход к каждому случаю  '
        'Провожу консультации онлайн и разрабатываю план лечения '
        'с учётом ваших потребностей ',
  );

  String _currentCity = 'Санкт-Петербург';

  void logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    final _auth = AuthService();
    _auth.signOut();
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
            _nameController.text = _initialName;
            _surnameController.text = _initialSurname;
            _phoneController.text = _initialPhone;
            _emailController.text = _initialEmail;
            _currentCity = _initialCity;
            _selectedImage = _initialAvatar;

            _specializationController.text = _initialSpecialization;
            _experienceController.text = _initialExperience;
            _placeOfWorkController.text = _initialPlaceOfWork;
            _priceController.text = _initialPrice;
            _aboutController.text = _initialAbout;

          });
        },
        onDone: () {
          final bool hasChanges =
              _nameController.text != _initialName ||
                  _surnameController.text != _initialSurname ||
                  _phoneController.text != _initialPhone ||
                  _emailController.text != _initialEmail ||
                  _currentCity != _initialCity ||
                  _selectedImage != _initialAvatar ||
                  _specializationController.text != _initialSpecialization ||
                  _experienceController.text != _initialExperience ||
                  _placeOfWorkController.text != _initialPlaceOfWork ||
                  _priceController.text != _initialPrice ||
                  _aboutController.text != _initialAbout;


          setState(() {
            _isEditing = false;

            if (hasChanges) {
              showCustomNotification(context, 'Данные Вашего профиля были успешно изменены!');
              // Логика сохранения
            } else {
              showCustomNotification(context, 'Вы ничего не изменили');
            }
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Блок аватара, имени и телефона
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1),
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
                                _isEditing
                                    ? TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _ProfilePageState.kPrimaryText,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                )
                                    : Text(
                                  _nameController.text,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: _ProfilePageState.kPrimaryText,
                                  ),
                                ),

                                if (_isEditing) ...[
                                  SizedBox(height: 6),
                                  DividerLine(),
                                  SizedBox(height: 6),
                                ],

                                _isEditing
                                    ? TextField(
                                  controller: _surnameController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: _ProfilePageState.kSecondaryText,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                )
                                    : Text(
                                  _surnameController.text,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: _ProfilePageState.kSecondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (!_isEditing) ...{
                            RatingBadge(
                              rating: '4,8',
                              subtitle: '23 заявки',
                              badgeColor: AppColors.additionalAccent,
                              badgeSize: 36,
                            ),
                          },

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Заголовок "Контактные данные"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
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

                  // Поля информации — без иконок, с тонкими разделителями
                  SettingsRow(
                    viewTitle: 'Номер телефона',
                    editTitle: 'Изменить телефон' ,
                    controller: _phoneController,
                    isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  SettingsRow(
                      viewTitle: 'Почта',
                      editTitle: 'Изменить почту' ,
                      controller: _emailController,
                      isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: "Город",
                    editTitle: "Изменить город",
                    value: _currentCity,
                    onTap: _isEditing ? _changeCityFuncion : null,
                    isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Работа',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Специализация',
                    editTitle: 'Изменить специализацию' ,
                    controller: _specializationController,
                    isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  SettingsRow(
                      viewTitle: 'Опыт',
                      editTitle: 'Изменить опыт' ,
                      controller: _experienceController,
                      isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Место работы',
                    editTitle: 'Изменить место работы' ,
                    controller: _placeOfWorkController,
                    isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Услуги',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Стоимость от',
                    editTitle: 'Изменить стоимость услуг' ,
                    controller: _priceController,
                    isEditable: _isEditing,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'О себе',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.white,
                    child: TextField(
                      controller: _aboutController,
                      readOnly: !_isEditing,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 16,
                      style: TextStyle(
                        color: _isEditing ? Color(0xFF1D1D1F) : Color(0xFF9BA1A5),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!_isEditing) ...{
                    // Кнопки действий
                    Column(
                      children: [
                        const SizedBox(height: 10),

                        const DividerLine(),

                        CustomButton(label: 'Выйти', color: AppColors.mainColor, onTap: () {logout();}),

                        const DividerLine(),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Для изменения логина'
                                '\nили пароля - обратитесь в поддержку',
                            style: TextStyle(
                              color: AppColors.grey600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  },

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
