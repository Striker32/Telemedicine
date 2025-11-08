import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../auth/Fb_doctor_model.dart';
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

// добавленные импорты

class ProfilePageDoctor extends StatefulWidget {
  const ProfilePageDoctor({Key? key}) : super(key: key);

  @override
  State<ProfilePageDoctor> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageDoctor> {
  // репозиторий для работы с коллекцией doctors
  final repo = DoctorRepository();

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

  // контроллеры
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
    text:
    'Специализируюсь на лечении кариеса, пульпита, заболеваний дёсен, а также проведении профессиональной гигиены полости рта\n\n'
        'Помогаю пациентам сохранить здоровье зубов и красивую улыбку, подбираю индивидуальный подход к каждому случаю\n\n'
        'Провожу консультации онлайн и разрабатываю план лечения с учётом ваших потребностей ',
  );

  String _currentCity = 'Санкт-Петербург';

  // флаг, чтобы контроллеры инициализировались один раз из snapshot
  bool _initializedFromSnapshot = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultAvatar();
    // initial-* будут инициализированы после первого snapshot; здесь можно установить дефолты
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
    try {
      final byteData = await rootBundle.load('assets/images/app/userProfile.png');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/userProfile.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      setState(() {
        _selectedImage = file;
        _initialAvatar = file; // ← сохраняем оригинал
      });
    } catch (e) {
      // ignore if asset not found
    }
  }

  void logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    final _auth = AuthService();
    _auth.signOut();
  }

  void _changeCityFuncion() async {
    // Пример: открыть страницу выбора города и ждать результата
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ChangeCityPage(selected: _currentCity)),
    );
    if (result != null && result != _currentCity) {
      setState(() => _currentCity = result);
    }
  }

  /// Сохранение изменений в Firestore (частичный апдейт через репозиторий)
  Future<void> _saveToFirestore(String uid) async {
    final patch = <String, dynamic>{
      'name': _nameController.text.trim(),
      'surname': _surnameController.text.trim(),
      'realEmail': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'city': _currentCity,
      'specialization': _specializationController.text.trim(),
      'experience': _experienceController.text.trim(),
      'placeOfWork': _placeOfWorkController.text.trim(),
      'price': _priceController.text.trim(),
      'about': _aboutController.text.trim(),
    };

    try {
      await repo.updateDoctor(uid, patch);

      // обновим initial-значения после успешного сохранения
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
      //_initialAvatar = _selectedImage;

      showCustomNotification(context, 'Данные Вашего профиля были успешно изменены!');
    } catch (e) {
      showCustomNotification(context, 'Ошибка при сохранении: $e');
    }
  }

  void _onCancelEdit() {
    setState(() {
      _isEditing = false;

      _nameController.text = _initialName;
      _surnameController.text = _initialSurname;
      _phoneController.text = _initialPhone;
      _emailController.text = _initialEmail;
      _currentCity = _initialCity;

      _specializationController.text = _initialSpecialization;
      _experienceController.text = _initialExperience;
      _placeOfWorkController.text = _initialPlaceOfWork;
      _priceController.text = _initialPrice;
      _aboutController.text = _initialAbout;

      _selectedImage = _initialAvatar;
      _initializedFromSnapshot = true;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _placeOfWorkController.dispose();
    _priceController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return const Scaffold(body: Center(child: Text('Пользователь не авторизован')));
    }
    final uid = firebaseUser.uid;

    return StreamBuilder<DoctorModel?>(
      stream: repo.watchDoctor(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snap.hasData || snap.data == null) {
          return Scaffold(
            backgroundColor: kBackground,
            appBar: ProfileAppBar(
              title: 'Профиль',
              isEditing: _isEditing,
              onEdit: () => setState(() => _isEditing = true),
              onCancel: _onCancelEdit,
              onDone: () async {
                await _saveToFirestore(uid);
                setState(() => _isEditing = false);
              },
              onSettings: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileSettingsPageUser()));
              },
            ),
            body: const Center(child: Text('Профиль не найден')),
          );
        }

        final model = snap.data!;

        // инициализация контроллеров единожды при первом snapshot
        if (!_isEditing && !_initializedFromSnapshot) {
          _nameController.text = model.name;
          _surnameController.text = model.surname;
          _emailController.text = model.realEmail;
          _phoneController.text = model.phone;
          _currentCity = model.city.isEmpty ? 'Не указан' : model.city;

          _specializationController.text = model.specialization;
          _experienceController.text = model.experience;
          _placeOfWorkController.text = model.placeOfWork;
          _priceController.text = model.price;
          _aboutController.text = model.about;

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

          _initializedFromSnapshot = true;
        }

        // здесь — твой оригинальный Scaffold UI, с небольшими заменами onCancel/onDone
        return Scaffold(
          backgroundColor: kBackground,
          appBar: ProfileAppBar(
            title: 'Профиль',
            isEditing: _isEditing,
            onEdit: () {
              setState(() {
                _isEditing = true;
              });
            },
            onCancel: _onCancelEdit,
            onDone: () async {
              final bool hasChanges =
                  _nameController.text != _initialName ||
                      _surnameController.text != _initialSurname ||
                      _phoneController.text != _initialPhone ||
                      _emailController.text != _initialEmail ||
                      _currentCity != _initialCity ||
                      _selectedImage?.path != _initialAvatar?.path ||
                      _specializationController.text != _initialSpecialization ||
                      _experienceController.text != _initialExperience ||
                      _placeOfWorkController.text != _initialPlaceOfWork ||
                      _priceController.text != _initialPrice ||
                      _aboutController.text != _initialAbout;

              setState(() {
                _isEditing = false;
              });

              if (hasChanges) {
                // Если нужно обновлять email в Firebase Auth при смене realEmail/phone,
                // добавь здесь логику реаутентификации и вызова AuthService.changeAuthEmail(...)
                await _saveToFirestore(uid);
              } else {
                showCustomNotification(context, 'Вы ничего не изменили');
              }
            },
            onSettings: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsPageUser()));
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
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
                                      const SizedBox(height: 6),
                                      DividerLine(),
                                      const SizedBox(height: 6),
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

                      SettingsRow(
                        viewTitle: 'Номер телефона',
                        editTitle: 'Изменить телефон',
                        controller: _phoneController,
                        isEditable: _isEditing,
                      ),

                      const DividerLine(),

                      SettingsRow(
                        viewTitle: 'Почта',
                        editTitle: 'Изменить почту',
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
                        editTitle: 'Изменить специализацию',
                        controller: _specializationController,
                        isEditable: _isEditing,
                      ),

                      const DividerLine(),

                      SettingsRow(
                        viewTitle: 'Опыт',
                        editTitle: 'Изменить опыт',
                        controller: _experienceController,
                        isEditable: _isEditing,
                      ),

                      const DividerLine(),

                      SettingsRow(
                        viewTitle: 'Место работы',
                        editTitle: 'Изменить место работы',
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
                        editTitle: 'Изменить стоимость услуг',
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
                            color: _isEditing ? const Color(0xFF1D1D1F) : const Color(0xFF9BA1A5),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

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
                              onTap: () {
                                logout();
                              },
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
            ),
          ),
        );
      },
    );
  }
}
