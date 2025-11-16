import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:last_telemedicine/PresenceService.dart';
import 'package:path_provider/path_provider.dart';

import 'package:last_telemedicine/components/Avatar/AvatarWithPicker.dart';
import 'package:last_telemedicine/components/SettingsRow.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../../auth/Fb_user_model.dart';
import '../../auth/auth_service.dart';
import '../../components/Appbar/ProfileAppBar.dart';
import '../../components/Avatar/DisplayAvatar.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../components/Loading.dart';
import '../../components/Notification.dart';
import '../../themes/AppColors.dart';
import '../Choose_profile.dart';

// импорт репозитория и модели (путь поправь под проект)

class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  State<ProfilePageUser> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageUser> {
  final repo = UserRepository();

  // Хранение данных для сброса изменений (инициализируются при первой загрузке из Firestore)
  String? _initialName;
  String? _initialSurname;
  String? _initialPhone;
  String? _initialEmail;
  String? _initialCity;
  File? _initialAvatar;

  // Дизайн-токены
  static const Color kBackground = Color(0xFFEFEFF4);
  static const Color kPrimaryText = Color(0xFF111111);

  bool _isEditing = false;

  File? _selectedImage;
  Uint8List? _avatarBytes; // байты из Firestore (Blob)

  // контроллеры
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  String _currentCity = 'Не указан';

  // флаг одноразовой инициализации контроллеров из snapshot
  bool _initializedFromSnapshot = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultAvatar();
  }

  Future<void> _loadDefaultAvatar() async {
    // убираем присвоение _selectedImage = file;
    try {
      final byteData = await rootBundle.load(
        'assets/images/app/userProfile.png',
      );
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/userProfile.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      _initialAvatar = file; // только для сброса, но не в _selectedImage
    } catch (_) {}
  }

  void _changeCityFuncion() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ChangeCityPage(selected: _currentCity)),
    );
    if (result != null && result != _currentCity) {
      setState(() => _currentCity = result);
    }
  }

  void logout(uid) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    PresenceService.init(uid, online: false);
    final _auth = AuthService();
    _auth.signOut();
  }

  // Сохранение профиля + аватар как Blob (60x60)
  Future<void> _saveToFirestore(String uid) async {
    final patch = <String, dynamic>{
      'name': _nameController.text.trim(),
      'surname': _surnameController.text.trim(),
      'realEmail': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'city': _currentCity,
    };

    // сохраняем аватар только если юзер выбрал новый файл
    if (_selectedImage != null && _selectedImage != _initialAvatar) {
      final bytes = await _selectedImage!.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        final resized = img.copyResize(decoded, width: 60, height: 60);
        final resizedBytes = Uint8List.fromList(img.encodePng(resized));
        patch['avatar'] = Blob(resizedBytes);
        _avatarBytes = resizedBytes;
      }
    }

    await repo.updateUser(uid, patch);
    // обновляем initial
    _initialAvatar = _selectedImage;

    // try {
    //   await repo.updateUser(uid, patch);
    //   // обновим "initial" на сохранённые значения
    //   _initialName = _nameController.text;
    //   _initialSurname = _surnameController.text;
    //   _initialPhone = _phoneController.text;
    //   _initialEmail = _emailController.text;
    //   _initialCity = _currentCity;
    //   _initialAvatar = _selectedImage;
    //   showCustomNotification(context, 'Данные Вашего профиля были успешно изменены!');
    // } catch (e) {
    //   showCustomNotification(context, 'Ошибка при сохранении: $e');
    // }
  }

  void _onCancelEdit() {
    setState(() {
      _isEditing = false;
      // сброс контроллеров к сохранённым initial
      if (_initialName != null) _nameController.text = _initialName!;
      if (_initialSurname != null) _surnameController.text = _initialSurname!;
      if (_initialPhone != null) _phoneController.text = _initialPhone!;
      if (_initialEmail != null) _emailController.text = _initialEmail!;
      if (_initialCity != null) _currentCity = _initialCity!;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return const Scaffold(
        body: Center(child: Text('Пользователь не авторизован')),
      );
    }
    final uid = firebaseUser.uid;

    return StreamBuilder<UserModel?>(
      stream: repo.watchUser(context, uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background2,
            body: const PulseLoadingWidget(),
          );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => ProfileSettingsPageUser()),
                );
              },
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Профиль не найден'),
                  const SizedBox(height: 30),
                  const DividerLine(),
                  CustomButton(
                    onTap: () {
                      logout(uid);
                    },
                    label: 'Выйти',
                    color: AppColors.mainColor,
                  ),
                  const DividerLine(),
                ],
              ),
            ),
          );
        }

        final model = snap.data!;

        // одноразовая инициализация контроллеров
        if (!_isEditing && (!_initializedFromSnapshot)) {
          _nameController.text = model.name;
          _surnameController.text = model.surname;
          _emailController.text = (model.realEmail.isNotEmpty
              ? model.realEmail
              : model.realEmail);
          _phoneController.text = model.phone;
          _currentCity = model.city.isEmpty ? 'Не указан' : model.city;

          _initialName = _nameController.text;
          _initialSurname = _surnameController.text;
          _initialPhone = _phoneController.text;
          _initialEmail = _emailController.text;
          _initialCity = _currentCity;

          // подтянем аватар из Firestore, если есть
          if (model.avatar != null) {
            _avatarBytes = model.avatar!.bytes;
          }

          _initializedFromSnapshot = true;
        }

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
                  _nameController.text != (_initialName ?? '') ||
                  _surnameController.text != (_initialSurname ?? '') ||
                  _phoneController.text != (_initialPhone ?? '') ||
                  _emailController.text != (_initialEmail ?? '') ||
                  _currentCity != (_initialCity ?? '') ||
                  _selectedImage?.path != _initialAvatar?.path;

              setState(() {
                _isEditing = false;
              });

              if (hasChanges) {
                await _saveToFirestore(uid);
              } else {
                showCustomNotification(context, 'Вы ничего не изменили');
              }
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
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
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
                                bottom: BorderSide(
                                  color: AppColors.dividerLine,
                                  width: 1,
                                ),
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
                                          initialImage:
                                              _selectedImage, // ← сюда приходит новый файл
                                          firestoreBytes:
                                              _avatarBytes, // ← старый Blob, если файла нет
                                          onImageSelected: (file) {
                                            setState(() {
                                              _selectedImage =
                                                  file; // ← обновляем состояние страницы
                                            });
                                          },
                                        )
                                      : DisplayAvatar(
                                          image: _selectedImage,
                                          firestoreBytes: _avatarBytes,
                                        ),

                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: _nameController,
                                          readOnly: !_isEditing,
                                          textAlign: TextAlign.start,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize: _isEditing ? 16 : 20,
                                            fontWeight: FontWeight.w400,
                                            color: kPrimaryText,
                                          ),
                                        ),
                                        if (_isEditing) ...[
                                          const SizedBox(height: 6),
                                          const DividerLine(),
                                          const SizedBox(height: 6),
                                        ],
                                        TextField(
                                          controller: _surnameController,
                                          readOnly: !_isEditing,
                                          textAlign: TextAlign.start,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            visualDensity:
                                                VisualDensity.compact,
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
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Введите свое имя и добавьте по желанию\nфотографию профиля',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF677076),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
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
                          const DividerLine(),
                          SettingsRow(
                            viewTitle: 'Номер телефона',
                            editTitle: 'Сменить Телефон',
                            controller: _phoneController,
                            isEditable: false,
                          ),
                          const DividerLine(),
                          SettingsRow(
                            viewTitle: 'Почта',
                            editTitle: 'Сменить почту',
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
                                    logout(uid);
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
