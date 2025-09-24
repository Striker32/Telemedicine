import 'package:flutter/material.dart';

class RegisterPageUser extends StatelessWidget {
  const RegisterPageUser({super.key});

  @override
  Widget build(BuildContext context) {
    // цветовая палитра — подбери точнее под макет
    final Color primaryText = Colors.black87;
    final Color hintGray = Colors.grey.shade400;
    final Color subtleGray = Colors.grey.shade200;
    final Color pinkBg = const Color(0xFFFFF0F3); // пример светло-розового фона кнопки
    final Color pinkText = const Color(0xFFFF6B86); // пример розового текста кнопки

    // общий отступ по горизонтали
    const horizontalPadding = 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        // Используем leading как текстовую кнопку слева
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
            onPressed: () => Navigator.maybePop(context),
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Назад',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 20, // оставил 20 — как в описании для hintText
                fontWeight: FontWeight.w400,
                color: Color(0xFFFF497C), // яркий розовый (пример)
              ),
            ),
          ),
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
                'Регистрация',
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
                  // TODO: переход на вход
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
                    color: Colors.grey.shade400,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Divider before first field (как в макете)
              const Divider(height: 1, thickness: 1, color: Colors.black12),

              // Поле: Имя и Фамилия
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Имя и Фамилия пациента',
                  hintStyle: TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: Colors.grey,
                    fontSize: 20, // как просил — hintText = 20px
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

              const Divider(height: 1, thickness: 1, color: Colors.black12),

              const SizedBox(height: 8),

              // Телефон: +7 и поле
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black12, width: 1),
                        ),
                      ),
                      width: 72,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                    const VerticalDivider(width: 1, thickness: 1, color: Colors.black12),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Ваш номер телефона',
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

              const SizedBox(height: 4),

              const Divider(height: 1, thickness: 1, color: Colors.black12),

              // Пароль
              TextFormField(
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
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
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
                  const Switch(value: false, onChanged: null),
                ],
              ),

              const SizedBox(height: 28),

              // Пустое пространство перед кнопкой, чтобы кнопка не прилипала к полю
              const SizedBox(height: 24),

              // Кнопка "Продолжить"
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: действие продолжить
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkBg,
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
                      color: pinkText,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36), // нижний отступ
            ],
          ),
        ),
      ),
    );
  }
}
