import 'dart:math';

import 'package:flutter/material.dart';

import '../../Services/Bottom_Navigator.dart';
import '../../auth/auth_service.dart';
import '../../components/Checkbox.dart';
import '../../components/Appbar/AppBarButton.dart' show AppBarButton;
import '../../components/Appbar/CustomAppBar.dart';
import '../../themes/AppColors.dart';

class LoginPageDoctor extends StatelessWidget {
  const LoginPageDoctor({super.key});

  @override
  Widget build(BuildContext context) {

    // общий отступ по горизонтали
    const horizontalPadding = 10.0;
    const dividerOfContinue = 10.0;

    final TextEditingController _loginController = TextEditingController();
    final TextEditingController _pwController = TextEditingController();

    void login(BuildContext context) async {
      // caught auth service
      final authService = AuthService();


      // DEBUG, DELETE
      final phone_num = _loginController.text;
      final pass = _pwController.text;


      final email = '${phone_num}@doctor.com';

      debugPrint('DEBUG: email="$email", pass length=${pass.length}');

      // try login
      try {
        await authService.signInWithEmailPassword(email, pass);

        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      // catch errors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
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
          padding: const EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
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
                'Пожалуйста, введите данные, которые\nВам предоставила поликлинника.',
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
              const Divider(height: 1, thickness: 1, color: AppColors.greyDivider),





              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyDivider, width: 1),
                  ),
                ),
                child: Row(
                  children: [


                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: _loginController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Логин',
                          hintStyle: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: Colors.grey,
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
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '  Пароль',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),



              // Политика конфиденциальности + переключатель
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Политика конфиденциальности',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  // В макете круглый свайч справа
                  // Использую значение false по умолчанию — заменить на состояние по необходимости.
                  Checkboxswitch(),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Клятва гиппократа',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  // В макете круглый свайч справа
                  // Использую значение false по умолчанию — заменить на состояние по необходимости.
                  Checkboxswitch(),
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
              login(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.additionalAccent,
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
                color: AppColors.mainColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
