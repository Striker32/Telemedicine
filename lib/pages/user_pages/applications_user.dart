import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ApplicationCard extends StatelessWidget {
  final String title;
  final String user;
  final String datetime;
  final String doctor;
  final String description;
  final String city;
  final int cost;
  final bool urgent;

  const ApplicationCard({
    Key? key,
    required this.title,
    required this.user,
    required this.datetime,
    required this.doctor,
    required this.description,
    required this.city,
    required this.cost,
    this.urgent = false,
  }) : super(key: key);

  // Палитра/токены
  static const _bgPage = Color(0xFFEFEFF4);     // фон страницы (как у тебя)
  static const _cardBg = Color(0xFFFFFFFF);
  static const _shadow = Color(0x1A000000);
  static const _label = Color(0xFF8E8E93);      // светло‑серый для лейблов
  static const _text = Color(0xFF000000);
  static const _pink = Color(0xFFFF2D55);       // iOS system pink
  static const _divider = Color(0xFFE5E5EA);    // тонкие разделители
  static const _btnGreyBg = Color(0xFFF2F2F7);  // светло‑серый фон правой кнопки
  static const _btnGreyText = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка: заголовок, справа молния
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: _text,
                    ),
                  ),
                ),
                if (urgent)
                  const Icon(Icons.flash_on, color: _pink, size: 18),
              ],
            ),

            const SizedBox(height: 12),

            // Аватар + имя + дата (в одной строке)
            Row(
              children: [
                // Серый круг‑аватар
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1D1D6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                // Имя
                Text(
                  user,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _text),
                ),
                const SizedBox(width: 8),
                // Тонкий разделитель‑точка (или маленький гап)
                Container(width: 1, height: 14, color: _divider),
                const SizedBox(width: 8),
                // Дата
                Text(
                  datetime,
                  style: const TextStyle(fontSize: 12, color: _label),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Врач
            const SizedBox(height: 12),
            const Text("Врач", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(doctor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Описание с фейдом без троеточия (только если переполнение)
            const SizedBox(height: 12),
            const Text("Описание", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            DescriptionFade(
              text: description,
              maxHeight: 44, // две строки
              textStyle: const TextStyle(fontSize: 14, color: _text, height: 1.25),
              fadeColor: _cardBg, // чтобы фейд совпадал с фоном карточки
            ),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Город
            const SizedBox(height: 12),
            const Text("Город", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(city, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Предложенная стоимость
            const SizedBox(height: 12),
            const Text("Предложенная стоимость", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 6),
            Text(
              "${_formatCost(cost)} ₽",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _text),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFECF1), // фон FFECF1
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4361),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Открыть заявку",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFF4361),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0x544A4B4E)), // 4A4B4E @33%
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0x544A4B4E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Удалить",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0x544A4B4E),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),





          ],
        ),
      ),
    );
  }

  static String _formatCost(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final posFromEnd = s.length - i - 1;
      if (posFromEnd % 3 == 0 && posFromEnd != 0) buf.write(' ');
    }
    return buf.toString();
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: ApplicationCard._divider);
  }
}

// Вставь выше ApplicationCard
String truncateWords(String text, int wordsCount, {String ellipsis = '…'}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return trimmed;
  final words = trimmed.split(RegExp(r'\s+'));
  if (words.length <= wordsCount) return trimmed;
  return words.take(wordsCount).join(' ') + ellipsis;
}

class DescriptionFade extends StatelessWidget {
  final String text;
  final double maxHeight;
  final TextStyle textStyle;
  final Color fadeColor;
  final int truncateToWords;

  const DescriptionFade({
    Key? key,
    required this.text,
    required this.maxHeight,
    required this.textStyle,
    required this.fadeColor,
    this.truncateToWords = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // сначала усечём текст до N слов
    final displayed = truncateWords(text, truncateToWords);

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final tp = TextPainter(
          text: TextSpan(text: displayed, style: textStyle),
          maxLines: null,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final exceeds = tp.height > maxHeight;

        if (!exceeds) {
          return Text(displayed, style: textStyle);
        }

        // Переполнение по высоте — обрезаем по высоте и накладываем фейд справа
        return Stack(
          children: [
            // Обрезанный по высоте текст
            ClipRect(
              child: SizedBox(
                height: maxHeight,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Text(displayed, style: textStyle),
                  ),
                ),
              ),
            ),

            // Горизонтальный фейд справа
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 44, // ширина области блюра
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 0), // блюр по X
                    child: Container(
                      // градиент поверх блюра, чтобы сделать переход плавнее
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            fadeColor.withOpacity(0.0),
                            fadeColor.withOpacity(0.45),
                            fadeColor.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],
        );
      },
    );
  }
}




class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFF4),
        body: SafeArea(
          child: Column(
            children: [
              // Верхняя область (белый фон)
              Container(
                width: double.infinity,
                color: const Color(0xFFFBFCFD),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Заявки",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Переключатель (TabBar)
                    SizedBox(
                      width: 214,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: SizedBox(
                              height: 37,
                              child: TabBar(
                                isScrollable: false,
                                indicator: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                indicatorColor: Colors.transparent,
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.black54,
                                tabs: const [
                                  SizedBox(
                                    width: 105,
                                    child: Tab(text: "Активные"),
                                  ),
                                  SizedBox(
                                    width: 105,
                                    child: Tab(text: "Архив"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(height: 9, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: TabBarView(
                  children: [
                    _ApplicationsEmptyView(),
                    _HistoryApplicationsEmptyView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationsEmptyView extends StatelessWidget {
  const _ApplicationsEmptyView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 0),
        const Text(
          "Нет заявок",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 24),

        // Кнопка "Создать заявку" с вызовом popup
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const CreateApplicationPopup(),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.add_circle, color: Colors.red, size: 32),
                SizedBox(height: 8),
                Text(
                  "Создать заявку",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: Center(
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
            //   child: Text(
            //     "В данном разделе Вы можете создать индивидуальную заявку и описать свою проблему, на которую откликнется нужный Вам врач.",
            //     textAlign: TextAlign.center,
            //     style: const TextStyle(fontSize: 13, color: Colors.black54),
            //   ),
            // ),

            child: ListView(
              padding: const EdgeInsets.only(top: 16),
              children: const [
                ApplicationCard(
                  title: "Стреляющая боль бокового верхнего резца",
                  user: "Георгий",
                  datetime: "23.03.2025 16:48",
                  doctor: "Стоматолог",
                  description: "Несколько дней мучает зубная боль. Длинный текст для проверки переполнения. "
                      "Дополнительное описание симптомов, провоцирующих факторов и сопутствующих ощущений.",
                  city: "Санкт-Петербург",
                  cost: 8000,
                  urgent: true,
                ),
                ApplicationCard(
                  title: "Консультация по брекетам",
                  user: "Анна",
                  datetime: "24.03.2025 10:15",
                  doctor: "Ортодонт",
                  description: "Хотела бы узнать про установку брекетов.",
                  city: "Москва",
                  cost: 5000,
                  urgent: false,
                ),
              ],
            ),


          ),
        ),
      ],
    );
  }
}

// ================= POPUP =================

class CreateApplicationPopup extends StatefulWidget {
  const CreateApplicationPopup({super.key});

  @override
  _CreateApplicationPopupState createState() => _CreateApplicationPopupState();
}

class _CreateApplicationPopupState extends State<CreateApplicationPopup> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  bool _urgent = false;

  final List<String> cities = [
    "Архангельск",
    "Вельск",
    "Волгоград",
    "Воронеж",
    "Екатеринбург",
    "Иваново",
    "Казань",
    "Каргополь",
    "Коряжма",
    "Котлас",
    "Красноярск",
    "Москва",
    "Мезень",
    "Мирный",
    "Нижний Новгород",
    "Новодвинск",
    "Новосибирск",
    "Няндома",
    "Онега",
    "Омск",
    "Пермь",
    "Ростов-на-Дону",
    "Самара",
    "Санкт-Петербург",
    "Северодвинск",
    "Тюмень",
    "Уфа",
    "Шенкурск",
    "Ярославль",
  ];

  bool get _allFilled => _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // отступ снизу равен высоте клавиатуры
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // чтобы можно было прокручивать поля
          child: Column(
            children: [
              // Серая полоска
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),

              // Верхняя панель
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Кнопка "Отменить" слева
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 16), // небольшой отступ от краёв экрана
                        child: Text(
                          "Отменить",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50), // отступ вниз до заголовка

                  // Заголовок "Создать заявку"
                  const Text(
                    "Создать заявку",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF1D1D1F),
                      fontWeight: FontWeight.w400, // без жирности
                    ),
                  ),

                  const SizedBox(height: 20), // отступ вниз перед текстом

                  // Текст под заголовком
                  const Text(
                    "Пожалуйста, укажите, кто Вам нужен, а также все необходимые для специалиста данные.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),

                  const SizedBox(height: 50), // отступ после текста
                ],
              ),


              // Поля ввода
              SingleChildScrollView(
                  child: Column(
                    children: [
                      // Поле 1
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5), // сдвиг надписи вправо
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Врач",
                            style: TextStyle(
                              color: Color(0xFF677076), // цвет надписи
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _controllers[0],
                        style: const TextStyle(
                          color: Color(0xFF1D1D1F), // цвет текста пользователя
                        ),
                        decoration: InputDecoration(
                          hintText: "Стоматолог",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9BA1A5), // цвет placeholder
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5), // фон поля
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none, // без рамки
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none, // без подсветки рамки
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),

                      // Поле 2
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5), // сдвиг надписи вправо
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Причина",
                            style: TextStyle(
                              color: Color(0xFF677076),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _controllers[1],
                        style: const TextStyle(
                          color: Color(0xFF1D1D1F),
                        ),
                        decoration: InputDecoration(
                          hintText: "Зубная боль",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9BA1A5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),

                      // Поле 3
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Подробное описание",
                            style: TextStyle(
                              color: Color(0xFF677076),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _controllers[2],
                        style: const TextStyle(
                          color: Color(0xFF1D1D1F),
                        ),
                        decoration: InputDecoration(
                          hintText: "Опишите подробно проблему",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9BA1A5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        maxLines: 3,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),

                      // Поле 4
                      Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Город",
                          style: TextStyle(
                            color: Color(0xFF9BA1A5),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _controllers[3].text.isNotEmpty ? _controllers[3].text : null,
                        items: cities
                            .map((city) => DropdownMenuItem<String>(
                          value: city,
                          child: Container(
                            color: _controllers[3].text == city
                                ? const Color(0xFFFFECF1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Text(
                              city,
                              style: const TextStyle(color: Color(0xFF1D1D1F)),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _controllers[3].text = val!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Выберите город",
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: const TextStyle(color: Color(0xFF1D1D1F)),
                        dropdownColor: const Color(0xFFF5F5F5),
                        menuMaxHeight: 200, // ограничение высоты списка
                      ),
                      const SizedBox(height: 12),


                      // Поле 5
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Предлагаемая стоимость",
                            style: TextStyle(
                              color: Color(0xFF677076),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _controllers[4],
                        style: const TextStyle(
                          color: Color(0xFF1D1D1F),
                        ),
                        decoration: InputDecoration(
                          hintText: "9000р",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9BA1A5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 60),

                      // Переключатель Срочно
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Срочно",
                            style: TextStyle(
                              color: Color(0xFF9BA1A5), // новый цвет
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 51,
                            height: 31,
                            child: Switch(
                              value: _urgent,
                              onChanged: (val) => setState(() => _urgent = val),
                              activeTrackColor: const Color(0xFF77D572),   // фон включен
                              inactiveTrackColor: const Color(0xFFE9E9EA), // фон выключен
                              activeColor: Colors.white,                     // кружок включен
                              inactiveThumbColor: Colors.white,             // кружок выключен
                              trackOutlineColor: MaterialStateProperty.all(Colors.transparent), // убираем обводку
                            ),
                          ),
                        ],
                      ),



                      const SizedBox(height: 20),

                      // Кнопка создать заявку
                      ElevatedButton(
                        onPressed: _allFilled ? () {} : null,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0), // убираем тень
                          minimumSize: MaterialStateProperty.all(const Size(double.infinity, 57)), // высота кнопки
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0xFFFFECF1).withOpacity(0.5); // фон неактивной кнопки
                            }
                            return const Color(0xFFFFECF1); // активная кнопка
                          }),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14), // закругление
                              side: BorderSide.none, // убираем рамку
                            ),
                          ),
                        ),
                        child: Text(
                          "Создать заявку",
                          style: TextStyle(
                            fontSize: 18, // размер текста
                            color: _allFilled
                                ? const Color(0xFFFF4361) // активная
                                : const Color(0xFFFF4361).withOpacity(0.5), // неактивная
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ссылка на политику
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Политика конфиденциальности",
                          style: TextStyle(
                            color: Color(0xFF677076),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= История заявок =================

class _HistoryApplicationsEmptyView extends StatelessWidget {
  const _HistoryApplicationsEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Нет архивных заявок"),
    );
  }
}
