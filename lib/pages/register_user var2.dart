import 'package:flutter/material.dart';

// Если у тебя есть отдельный компонент AppBarBackButton, можно импортировать и использовать.
// Здесь делаю inline, чтобы было самодостаточно.
class RegisterPageUser extends StatefulWidget {
  const RegisterPageUser({super.key});

  @override
  State<RegisterPageUser> createState() => _RegisterPageUserState();
}

class _RegisterPageUserState extends State<RegisterPageUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _privacyAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Цвета — подбери точнее по макету (здесь примерные)
    const bgColor = Colors.white;
    const pinkBg = Color(0xFFFFF4F6); // светлый фон кнопки (пример)
    const pinkTextColor = Color(0xFFFF6B86); // цвет текста кнопки (пример)
    const backPink = Color(0xFFFF497C); // цвет слова "Назад"
    const dividerColor = Color(0xFFE6E6E6); // тонкая разделительная линия
    const hintGray = Color(0xFF9B9B9B); // hint text color example

    const horizontalPadding = 24.0;
    const hintFontSize = 20.0;
    const textFont = 'SF Pro Display';

    return Scaffold(
      backgroundColor: bgColor,
      // Используем PreferredSize + title для того, чтобы кнопка "Назад" не
      // резалась ограничениями leading.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        // SafeArea внутри PreferredSize гарантирует корректные отступы для вырезов
        child: SafeArea(
          child: Container(
            color: bgColor,
            // делаем простой row, где слева — кнопка, остальное пусто (для свободного пространства)
            child: Row(
              children: [
                // Слева большой кликабельный текст "Назад"
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Назад',
                      style: TextStyle(
                        fontFamily: textFont,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: backPink,
                      ),
                    ),
                  ),
                ),
                // Заполняем остальное пространство (чтобы кнопка не резалась)
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 36), // отступ сверху
              // Заголовок
              const Text(
                'Регистрация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: textFont,
                  fontSize: 44, // большой заголовок (подправь, если нужно)
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Подзаголовок
              const Text(
                'Пожалуйста, зарегистрируйтесь для\nдальнейшего пользования приложением.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: textFont,
                  fontSize: 16, // подпись чуть меньше
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              // Ссылка "У меня уже есть профиль"
              TextButton(
                onPressed: () {
                  // TODO: переход на экран логина
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'У меня уже есть профиль',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: textFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),

              // БОЛЬШОЙ отступ перед полями (как в макете)
              const SizedBox(height: 40),

              // Divider (как в макете верхняя линия перед первым полем)
              Divider(height: 1, thickness: 1, color: dividerColor),

              // === Поле: имя и фамилия ===
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Имя и Фамилия пациента',
                  hintStyle: const TextStyle(
                    fontFamily: textFont,
                    fontSize: hintFontSize,
                    fontWeight: FontWeight.w400,
                    color: hintGray,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
                style: const TextStyle(
                  fontFamily: textFont,
                  fontSize: hintFontSize,
                  color: Colors.black87,
                ),
                cursorColor: backPink, // каретка розовая
              ),

              Divider(height: 1, thickness: 1, color: dividerColor),

              const SizedBox(height: 8),

              // === Поле: Телефон с префиксом +7 ===
              Container(
                // нижняя линия как у макета
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: dividerColor, width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // префикс +7
                    Container(
                      width: 72,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: dividerColor, width: 1),
                        ),
                      ),
                      child: const Text(
                        '+7',
                        style: TextStyle(
                          fontFamily: textFont,
                          fontSize: hintFontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // пространство между префиксом и полем (тонкая)
                    const SizedBox(width: 12),

                    // основной инпут
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Ваш номер телефона',
                          hintStyle: TextStyle(
                            fontFamily: textFont,
                            fontSize: hintFontSize,
                            fontWeight: FontWeight.w400,
                            color: hintGray,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                        style: const TextStyle(
                          fontFamily: textFont,
                          fontSize: hintFontSize,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Divider(height: 1, thickness: 1, color: dividerColor),

              // === Пароль ===
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Пароль',
                  hintStyle: TextStyle(
                    fontFamily: textFont,
                    fontSize: hintFontSize,
                    fontWeight: FontWeight.w400,
                    color: hintGray,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
                style: const TextStyle(
                  fontFamily: textFont,
                  fontSize: hintFontSize,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Политика конфиденциальности + переключатель
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Политика конфиденциальности',
                    style: TextStyle(
                      fontFamily: textFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  // Если нужно точнее — заменить на кастомный вид переключателя, как в макете
                  Switch(
                    value: _privacyAccepted,
                    onChanged: (v) => setState(() => _privacyAccepted = v),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Крупная кнопка "Продолжить"
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: обработка клика (валидация, переход)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    // убираем внутренние отступы, чтобы текст был по центру
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Продолжить',
                    style: const TextStyle(
                      fontFamily: textFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: pinkTextColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
