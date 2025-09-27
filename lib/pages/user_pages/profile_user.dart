import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Индекс выбранной вкладки: Профиль
  int _currentIndex = 3;

  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4);
  static const Color kTitleColor = Color(0xFF111111);
  static const Color kLinkColor = Colors.red; // цвет "Настройки" и "Изменить"
  static const Color kPrimaryText = Color(0xFF111111);
  static const Color kSecondaryText = Color(0xFF6F7177);
  static const Color kDivider = Color(0xFFE9E9ED);
  static const Color kNavSelected = Color(0xFF2F80ED);
  static const Color kNavUnselected = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Верхняя панель: Настройки | Профиль | Изменить
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: открыть настройки
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kLinkColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Настройки',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: режим редактирования профиля
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kLinkColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Изменить',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // Блок аватара, имени и телефона
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE0E0E6),
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                    // Для реальной аватарки: backgroundImage: AssetImage(...) / NetworkImage(...)
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Георгий',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kPrimaryText),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '+7 900 502 9229',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kSecondaryText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Заголовок "Контактные данные"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Контактные данные',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kPrimaryText),
              ),
            ),

            const SizedBox(height: 8),

            // Поля информации — без иконок, с тонкими разделителями
            const _InfoField(title: 'Номер телефона', value: '+7 900 502 9229'),
            const _DividerLine(),
            const _InfoField(title: 'Почта', value: 'example@mail.ru'),
            const _DividerLine(),
            const _InfoField(title: 'Город', value: 'Санкт-Петербург'),

            const SizedBox(height: 20),

            // Кнопки действий
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: изменить пароль
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade200,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Изменить пароль'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: выход из аккаунта
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFE74C3C),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Выйти'),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),

      // Нижний таббар
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          // TODO: навигация по вкладкам
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kNavSelected,
        unselectedItemColor: kNavUnselected,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Заявки'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Чаты'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

// Поле информации: заголовок и значение, без иконок
class _InfoField extends StatelessWidget {
  final String title;
  final String value;

  const _InfoField({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: действие по тапу поля (если требуется)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _ProfilePageState.kSecondaryText),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ProfilePageState.kPrimaryText),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: _ProfilePageState.kDivider),
    );
  }
}
