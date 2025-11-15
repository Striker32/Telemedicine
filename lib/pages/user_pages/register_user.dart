import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_service.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/themes/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/Checkbox.dart';
import '../../components/Appbar/AppBarButton.dart' show AppBarButton;
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Notification.dart';
import 'login_user.dart';

class RegisterPageUser extends StatefulWidget {
  const RegisterPageUser({super.key});

  @override
  State<RegisterPageUser> createState() => _RegisterPageUserState();
}

class _RegisterPageUserState extends State<RegisterPageUser> {
  bool _isPrivacyChecked = false;
  bool _isOathChecked = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool get _isFormValid {
    return _isPrivacyChecked &&
        _isOathChecked &&
        _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _pwController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // цветовая палитра

    // общий отступ по горизонтали
    const horizontalPadding = 10.0;
    const dividerOfContinue = 10.0;

    void register(BuildContext context) async {
      final _auth = AuthService();

      final phone_num = _phoneController.text;
      final pass = _pwController.text;
      final name = _nameController.text.split(" ")[0];
      String? surname;
      try {
        surname = _nameController.text.split(" ")[1];
      } catch (e) {
        surname = "";
      }

      final email = '${phone_num}@user.com';

      debugPrint('DEBUG: email="$email", pass length=${pass.length}');

      try {
        await _auth.signUpUserWithEmailPassword(
          pseudoemail: email,
          password: pass,
          phone: phone_num,
          name: name,
          surname: surname,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      // catch errors
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showCustomNotification(context, 'Слишком слабый пароль');
        } else if (e.code == 'email-already-in-use') {
          showCustomNotification(context, 'Этот номер телефона уже занят');
        } else {
          showCustomNotification(
            context,
            'Произошла ошибка, попробуйте ещё раз',
          );
        }
      } catch (e) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('weak-password')) {
          showCustomNotification(context, 'Слишком слабый пароль');
        } else if (msg.contains('email-already-in-use') ||
            msg.contains('email already in use')) {
          showCustomNotification(context, 'Этот номер телефона уже занят');
        } else {
          showCustomNotification(
            context,
            'Произошла ошибка, попробуйте ещё раз',
          );
        }
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
                'Регистрация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primaryText,
                ),
              ),

              const SizedBox(height: 18),

              // Подзаголовок
              Text(
                'Пожалуйста, зарегистрируйтесь для\nдальнейшего пользования приложением.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 22),

              // Ссылка "У меня уже есть профиль"
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, // 'context' здесь очень важен!
                    MaterialPageRoute(
                      builder: (context) => LoginPageUser(),
                    ), // Замените DoctorScreen() на ваш виджет
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'У меня уже есть профиль',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.addLightText,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Divider before first field (как в макете)
              DividerLine(),

              // Поле: Имя и Фамилия
              TextFormField(
                onChanged: (_) => setState(() {}),
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Имя и Фамилия пациента',
                  hintStyle: TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: AppColors.addLightText,
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

              DividerLine(),

              // Телефон: +7 и поле
              Container(
                // сделать палку снизу
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
                      alignment: Alignment.center,
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
                        controller: _phoneController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
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
                  controller: _pwController,
                  obscureText: true,
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
                          'Политику обработки\nперсональных данных',
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
                register(context);
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
