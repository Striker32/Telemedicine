import 'package:flutter/material.dart';

import '../../components/Checkbox.dart';
import '../../components/AppBarButton.dart' show AppBarButton;
import '../../themes/AppColors.dart';

class LoginPageDoctor extends StatelessWidget {
  const LoginPageDoctor({super.key});

  @override
  Widget build(BuildContext context) {

    // общий отступ по горизонтали
    const horizontalPadding = 10.0;
    const dividerOfContinue = 10.0;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // убираем стандартные рамки
        titleSpacing: 0, // убираем отступы слева
        title: Align(
          alignment: Alignment.centerLeft,
          child: AppBarButton(),
        ),
      ),


      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
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
              const Divider(height: 1, thickness: 1, color: Colors.black12),





              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Row(
                  children: [


                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
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
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: TextFormField(
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

              const SizedBox(height: 18),



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

              const SizedBox(height: 10),

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



              const SizedBox(height: 28),


              // Пустое пространство перед кнопкой, чтобы кнопка не прилипала к полю
              const SizedBox(height: 50),

              // Кнопка "Продолжить"
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: действие продолжить
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
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ),

// нижний отступ
            ],
          ),
        ),
      ),
    );
  }
}
