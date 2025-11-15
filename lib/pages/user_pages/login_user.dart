import 'package:flutter/material.dart';
import 'package:last_telemedicine/Services/Bottom_Navigator.dart';
import 'package:last_telemedicine/auth/auth_gate.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/user_pages/profile_user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/auth_service.dart';
import '../../components/Checkbox.dart';
import '../../components/Appbar/AppBarButton.dart' show AppBarButton;
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Notification.dart';
import '../../themes/AppColors.dart';

class LoginPageUser extends StatefulWidget {
  const LoginPageUser({super.key});

  @override
  State<LoginPageUser> createState() => _LoginPageUserState();
}

class _LoginPageUserState extends State<LoginPageUser> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _isPrivacyChecked = false;
  bool _isOathChecked = false;

  bool get _isFormValid {
    return _isPrivacyChecked &&
        _isOathChecked &&
        _phoneController.text.trim().isNotEmpty &&
        _pwController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // цветовая палитра

    // общий отступ по горизонтали
    const horizontalPadding = 10.0;

    void login(BuildContext context) async {
      // caught auth service
      final authService = AuthService();

      // DEBUG, DELETE
      final phone_num = _phoneController.text;
      final pass = _pwController.text;

      final email = '${phone_num}@user.com';

      debugPrint('DEBUG: email="$email", pass length=${pass.length}');

      // try login
      try {
        await authService.signInWithEmailPassword(email, pass);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (Route<dynamic> route) => false,
        );
      }
      // catch errors
      catch (e) {
        showCustomNotification(context, 'Неправильный логин или пароль');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: AppBarButton(label: 'Назад'),
        backgroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Заголовок
              const Text(
                'Авторизация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              // Подзаголовок
              Text(
                'Пожалуйста, введите данные, которые\nВы указывали при регистрации.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 22),

              const SizedBox(height: 80),

              // Divider before first field (как в макете)
              const DividerLine(),

              // Телефон: +7 и поле
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyDivider, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: AppColors.greyDivider,
                            width: 1,
                          ),
                        ),
                      ),
                      width: 72,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ), // размер палка справа от +7
                      alignment: Alignment.centerLeft,
                      // граница между кодом и полем — реализована визуально через контейнер
                      child: Center(
                        child: const Text(
                          '+7',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          counterText: "",
                          hintText: 'Ваш номер телефона',
                          hintStyle: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: AppColors.addLightText,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                        ),
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: AppColors.primaryText,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Пароль
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyDivider, width: 1),
                  ),
                ),
                child: TextFormField(
                  onChanged: (_) => setState(() {}),
                  obscureText: true,
                  controller: _pwController,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Согласие на передачу данных приложению, отметьте ниже, если Вы прочитали и принимаете:',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.addLightText,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Политика конфиденциальности + переключатель (ссылка)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse('https://example.com/privacy'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          'Пользовательское соглашение',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                      Checkboxswitch(
                        value: _isPrivacyChecked,
                        onChanged: (val) {
                          setState(() {
                            _isPrivacyChecked = val;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Клятва гиппократа + переключатель (ссылка)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse('https://example.com/oath'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          'Политику обработки персональных\nданных',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                      Checkboxswitch(
                        value: _isOathChecked,
                        onChanged: (val) {
                          setState(() {
                            _isOathChecked = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              if (_isFormValid) {
                login(context);
              } else {
                showCustomNotification(
                  context,
                  'Пожалуйста, заполните все поля!',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid
                  ? AppColors.additionalAccent
                  : const Color(0xFFFDF4F7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Продолжить',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: _isFormValid
                    ? AppColors.mainColor
                    : const Color(0xFFFDA0AF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
