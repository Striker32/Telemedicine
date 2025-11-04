import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../components/Confirmation.dart';
import '../../components/Notification.dart';

class ApplicationCard extends StatelessWidget {
  final String title;
  final String user;
  final String datetime;
  final String doctor;
  final String description;
  final String city;
  final int cost;
  final bool urgent;

// поле: список откликнувшихся врачей
  final List<Map<String, dynamic>> responders;

// флаг, есть ли отклики (по умолчанию false)
  final bool hasResponse;

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
    this.responders = const [],
    this.hasResponse = false,
  }) : super(key: key);


  // Палитра/токены
  static const _bgPage = Color(0xFFEFEFF4);     // фон страницы (как у тебя)
  static const _cardBg = Color(0xFFFFFFFF);
  static const _shadow = Color(0x1A000000);
  static const _label = Color(0xFF1D1D1F);      // светло‑серый для лейблов
  static const _text = Color(0xFF000000);
  static const _pink = Color(0xFFFF2D55);       // iOS system pink
  static const _divider = Color(0xFFE5E5EA);    // тонкие разделители
  static const _btnGreyBg = Color(0xFFF2F2F7);
  static const _btnGreyText = Color(0xFF8E8E93);
  static const _gray = Color(0xFF9BA1A5);

  @override
  Widget build(BuildContext context) {
    final bool hasResponse = responders.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: hasResponse ? const Color(0xFFFFFAFB) : _cardBg,
        borderRadius: BorderRadius.circular(14),
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
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: _text,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                if (urgent)
                  SvgPicture.asset(
                    'assets/images/icons/lightning.svg',
                    width: 30,
                    height: 25
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Аватар + имя + дата (в одной строке)
            Row(
              children: [
                SvgPicture.asset(
                    'assets/images/icons/userProfile.svg',
                    width: 29,
                    height: 29
                ),
                const SizedBox(width: 10),
                // Имя
                Text(
                  user,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text),
                ),
                const SizedBox(width: 20),
                SvgPicture.asset(
                    'assets/images/icons/calendar.svg',
                    width: 28,
                    height: 28
                ),
                const SizedBox(width: 10),
                // Дата
                Text(
                  datetime,
                  style: const TextStyle(fontSize: 16, color: _gray, fontWeight: FontWeight.w400),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Врач
            const SizedBox(height: 12),
            const Text("Врач", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(doctor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Описание с фейдом без троеточия (только если переполнение)
            const SizedBox(height: 12),
            const Text("Описание", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            DescriptionFade(
              text: description,
              maxHeight: 44, // две строки
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text),
              fadeColor: _cardBg, // чтобы фейд совпадал с фоном карточки
            ),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Город
            const SizedBox(height: 12),
            const Text("Город", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Предложенная стоимость
            const SizedBox(height: 12),
            const Text("Предложенная стоимость", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 6),
            Text(
              "${_formatCost(cost)} ₽",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        // если есть отклики — кнопка ярко-красная, иначе светло-розовая
                        color: hasResponse ? const Color(0xFFFF4361) : const Color(0xFFFFECF1),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            final initialValues = [
                              doctor,
                              title,
                              description,
                              city,
                              cost.toString(),
                            ];

                            // Передаём responders (поле класса ApplicationCard)
                            final result = await showChangeApplicationPopup(
                              context,
                              initialValues: initialValues,
                              urgent: urgent,
                              datetime: datetime,
                              responders: responders,
                            );

                            if (result != null) {
                              debugPrint('Попап вернул: $result');
                            } else {
                              debugPrint('Пользователь отменил');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // иконка: белая версия при отклике, обычная при отсутствии
                              if (hasResponse)
                                SvgPicture.asset(
                                  'assets/images/icons/applications-white.svg',
                                  width: 20,
                                  height: 20,
                                )
                              else
                                SvgPicture.asset(
                                  'assets/images/icons/applications.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              const SizedBox(height: 6),
                              Text(
                                "Открыть заявку",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: hasResponse ? const Color(0xFFF5F5F7) : const Color(0xFFFF4361),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: hasResponse ? const Color(0xFFFFFAFB) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0x544A4B4E)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/trash.svg',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Удалить",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0x544A4B4E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                        ),
                      ),
                    ),
                  ),
                )

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

class HistoryApplicationCard extends StatelessWidget {
  final String title;
  final String user;
  final String datetime;
  final String doctor;
  final String description;
  final String city;
  final String rating;
  final int cost;

  final List<dynamic> responder;

  const HistoryApplicationCard({
    Key? key,
    required this.title,
    required this.user,
    required this.datetime,
    required this.doctor,
    required this.description,
    required this.city,
    required this.cost,
    required this.responder,
    this.rating = '',
  }) : super(key: key);


  // Палитра/токены
  static const _bgPage = Color(0xFFEFEFF4);     // фон страницы (как у тебя)
  static const _cardBg = Color(0xFFFFFFFF);
  static const _shadow = Color(0x1A000000);
  static const _label = Color(0xFF1D1D1F);      // светло‑серый для лейблов
  static const _text = Color(0xFF000000);
  static const _pink = Color(0xFFFF2D55);       // iOS system pink
  static const _divider = Color(0xFFE5E5EA);    // тонкие разделители
  static const _btnGreyBg = Color(0xFFF2F2F7);
  static const _btnGreyText = Color(0xFF8E8E93);
  static const _gray = Color(0xFF9BA1A5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
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
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: _text,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                if (rating != '')
                  Container(
                    width: 48,
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECF1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/star.svg',
                          width: 14,
                          height: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF4361),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Аватар + имя + дата (в одной строке)
            Row(
              children: [
                SvgPicture.asset(
                    'assets/images/icons/userProfile.svg',
                    width: 29,
                    height: 29
                ),
                const SizedBox(width: 10),
                // Имя
                Text(
                  user,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text),
                ),
                const SizedBox(width: 20),
                SvgPicture.asset(
                    'assets/images/icons/calendar.svg',
                    width: 28,
                    height: 28
                ),
                const SizedBox(width: 10),
                // Дата
                Text(
                  datetime,
                  style: const TextStyle(fontSize: 16, color: _gray, fontWeight: FontWeight.w400),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: const Color(0xFFF5F6F7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            final initialValues = [
                              doctor,
                              title,
                              description,
                              city,
                              cost.toString(),
                            ];

                            // Передаём responders (поле класса ApplicationCard)
                            final result = await showHistoryApplicationPopup(
                              context,
                              initialValues: initialValues,
                              datetime: datetime,
                              responder: responder,
                              hasRating: rating != '',
                              rating: rating,
                            );

                            if (result != null) {
                              debugPrint('Попап вернул: $result');
                            } else {
                              debugPrint('Пользователь отменил');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                SvgPicture.asset(
                                  'assets/images/icons/applications-black.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              const SizedBox(height: 6),
                              Text(
                                "Открыть заявку",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF1D1D1F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFFFE3B30)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final confirmed = await showConfirmationDialog(
                              context,
                              'Удалить заявку',
                              'Данная заявка будет полностью\n удалена из базы данных приложения.\n Врачи больше не смогут её посмотреть.',
                              'Удалить',
                              'Отмена',
                            );

                            if (confirmed) {
                              showCustomNotification(context, 'Заявка была успешно удалена');
                              //   TODO: Логика удаления заявки
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/trash-red.svg',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Удалить",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFE3B30),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )

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
    this.truncateToWords = 5, // Кол-во слов для отображения
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
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Верхняя область (белый фон) с заголовком и кнопкой Создать
                Container(
                  width: double.infinity,
                  color: const Color(0xFFFBFCFD),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Заголовок центрирован, кнопка справа
                      SizedBox(
                        height: 36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Центрированный заголовок
                            const Center(
                              child: Text(
                                "Заявки",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Кнопка Создать справа
                            Positioned(
                              right: 10,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const CreateApplicationPopup(),
                                    );
                                },
                                child: const Text(
                                  'Создать',
                                  style: TextStyle(
                                    color: Color(0xFFFF4361),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                      DividerLine(),
                    ],

                  ),
                ),



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
      ),

    );
  }
}

// ================= История заявок =================

class _HistoryApplicationsEmptyView extends StatelessWidget {
  const _HistoryApplicationsEmptyView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "3 архивных заявки",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 0),

          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2),
            children: const [


              HistoryApplicationCard(
                title: "Воспаление десны и боль при накусывании",
                user: "Андрей",
                datetime: "23.03.2025 16:48",
                doctor: "Стоматолог",
                description:
                "Около недели ощущаю боль в области верхнего зуба при накусывании. Сначала было лёгкое покалывание, но за последние пару дней десна припухла и появилась ноющая боль. Иногда чувствуется неприятный вкус во рту. Обезболивающие действуют недолго. Подозреваю воспаление корня или десны. Хотелось бы получить консультацию и при необходимости провести лечение, пока ситуация не ухудшилась.",
                city: "Санкт-Петербург",
                cost: 8200,
                rating: '4',
                responder: [
                  {
                    'id': 'doc001',
                    'name': 'Иван И.',
                    'surname': 'Иванов',
                    'rating': 4.6,
                    'completed': 128,
                    'specialization': 'Стоматолог',
                    'phone': '+7 900 000 00 00',
                    'email': 'ivan@example.com',
                    'city': 'Москва',
                    'experience': '10 лет',
                    'price': '5000',
                    'workplace': 'Клиника Здоровья',
                    'about':
                    'Опытный специалист в терапевтической стоматологии. Занимается лечением кариеса, пульпита и заболеваний десен с использованием современных технологий. Регулярно проходит повышение квалификации и уделяет внимание комфорту пациентов. Отличается аккуратностью, внимательностью и доброжелательным подходом.',
                  },
                ],
              ),

              HistoryApplicationCard(
                title: "Ощущение жжения и боли после переохлаждения",
                user: "Сергей",
                datetime: "01.01.2025 11:48",
                doctor: "Проктолог",
                description:
                "После переохлаждения почувствовал лёгкое жжение и зуд в области прямой кишки, позже появилась боль при сидении. Сначала думал, что пройдёт само, но симптомы стали усиливаться. Неприятные ощущения сохраняются и мешают вести привычный образ жизни. Хотелось бы пройти осмотр, чтобы исключить воспаление или геморрой и начать лечение. Обратиться нужно в ближайшее время, пока ситуация не ухудшилась.",
                city: "Санкт-Петербург",
                cost: 7500,
                responder: [
                  {
                    'id': 'doc002',
                    'name': 'Олег П.',
                    'surname': 'Морозов',
                    'rating': 4.7,
                    'completed': 203,
                    'specialization': 'Проктолог',
                    'phone': '+7 921 555 33 22',
                    'email': 'morozov.proct@example.com',
                    'city': 'Санкт-Петербург',
                    'experience': '11 лет',
                    'price': '5800',
                    'workplace': 'Медицинский центр «АльфаМед»',
                    'about':
                    'Врач-проктолог с большим опытом работы. Проводит диагностику и лечение геморроя, анальных трещин и воспалительных заболеваний прямой кишки. Придерживается деликатного и внимательного подхода к пациентам, использует современные малоинвазивные методы. Известен своей корректностью и профессионализмом.',
                  },
                ],
              ),

              HistoryApplicationCard(
                title: "Проблемы с произношением звуков",
                user: "Алексей",
                datetime: "03.03.2025 04:00",
                doctor: "Логопед",
                description:
                "Стал замечать, что некоторые звуки произношу нечетко, особенно при быстрой речи. Иногда окружающие просят повторить сказанное. Пробовал тренироваться самостоятельно, но особых улучшений нет. Хотел бы пройти консультацию логопеда, чтобы понять причину и подобрать упражнения. Возможно, проблема связана с артикуляцией или перенапряжением речевых мышц. Хотелось бы восстановить нормальную дикцию, так как это мешает в общении и работе.",
                city: "Санкт-Петербург",
                cost: 4000,
                rating: '2',
                responder: [
                  {
                    'id': 'doc003',
                    'name': 'Екатерина Н.',
                    'surname': 'Лебедева',
                    'rating': 4.9,
                    'completed': 186,
                    'specialization': 'Логопед',
                    'phone': '+7 900 111 22 77',
                    'email': 'lebedeva.logoped@example.com',
                    'city': 'Москва',
                    'experience': '9 лет',
                    'price': '3500',
                    'workplace': 'Центр речи и коммуникации «Голос+»',
                    'about':
                    'Профессиональный логопед-дефектолог. Работает со взрослыми и детьми, помогает устранить дефекты речи, улучшить дикцию и развить артикуляцию. Использует современные методики коррекции речи и дыхательные упражнения. Отличается внимательностью, терпением и индивидуальным подходом к каждому клиенту.',
                  },
                ],
              ),


            ],
          ),
        ],
      ),
    );
  }
}

// ==================== Заявки =====================
class _ApplicationsEmptyView extends StatelessWidget {
  const _ApplicationsEmptyView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "2 активных заявки",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 0),

          // Кнопка "Создать заявку" с вызовом popup
          // GestureDetector(
          //   onTap: () {
          //     showModalBottomSheet(
          //       context: context,
          //       isScrollControlled: true,
          //       backgroundColor: Colors.transparent,
          //       builder: (context) => const CreateApplicationPopup(),
          //     );
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 10),
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(vertical: 24),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(12),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.05),
          //           blurRadius: 4,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: const Column(
          //       children: [
          //         Icon(Icons.add_circle, color: Colors.red, size: 32),
          //         SizedBox(height: 8),
          //         Text(
          //           "Создать заявку",
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w600,
          //             color: Colors.red,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          //   child: Text(
          //     "В данном разделе Вы можете создать индивидуальную заявку и описать свою проблему, на которую откликнется нужный Вам врач.",
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(fontSize: 13, color: Colors.black54),
          //   ),
          // ),

          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2),
            children: const [

              ApplicationCard(
                title: "Острая боль бокового верхнего резца",
                user: "Георгий",
                datetime: "23.03.2025 16:48",
                doctor: "Стоматолог",
                description:
                "Несколько дней беспокоит боль в верхнем резце. Сначала реагировал на холодное и горячее, теперь болит постоянно и отдает в висок. Обезболивающие помогают слабо. Требуется осмотр и лечение.",
                city: "Санкт-Петербург",
                cost: 8000,
                urgent: true,
                responders: [
                  {
                    'id': 'doc001',
                    'name': 'Иван',
                    'surname': 'Иванов',
                    'rating': 4.8,
                    'completed': 154,
                    'specialization': 'Стоматолог',
                    'phone': '+7 911 234 56 78',
                    'email': 'ivanov.dent@example.com',
                    'city': 'Москва',
                    'experience': '12 лет',
                    'price': '5500',
                    'workplace': 'Стоматологическая клиника «Улыбка»',
                    'about':
                    'Специализируется на терапевтическом и эстетическом лечении зубов. Владеет современными методиками реставрации и эндодонтического лечения под микроскопом. Постоянно повышает квалификацию, участвует в международных стоматологических конференциях. Работает с пациентами любого возраста, делает акцент на безболезненности процедур и сохранении естественной структуры зуба. Ведёт приём в Москве и Санкт-Петербурге.',
                  },
                  {
                    'id': 'doc002',
                    'name': 'Мария',
                    'surname': 'Кузнецова',
                    'rating': 4.7,
                    'completed': 97,
                    'specialization': 'Стоматолог',
                    'phone': '+7 921 876 54 32',
                    'email': 'kuznetsova.dent@example.com',
                    'city': 'Санкт-Петербург',
                    'experience': '8 лет',
                    'price': '5200',
                    'workplace': 'Клиника «DentalPro»',
                    'about':
                    'Опытный врач-стоматолог с внимательным подходом к каждому пациенту. Специализируется на лечении кариеса, пульпита и заболеваний дёсен, применяет современные обезболивающие препараты и щадящие технологии. Регулярно проходит обучение по современным методам эстетической реставрации и профессиональной гигиены полости рта. Известна своей аккуратностью, вниманием к деталям и стремлением сделать лечение максимально комфортным.',
                  },
                  {
                    'id': 'doc003',
                    'name': 'Александр',
                    'surname': 'Смирнов',
                    'rating': 4.9,
                    'completed': 182,
                    'specialization': 'Стоматолог',
                    'phone': '+7 900 333 22 11',
                    'email': 'smirnov.stom@example.com',
                    'city': 'Москва',
                    'experience': '15 лет',
                    'price': '6000',
                    'workplace': 'Сеть клиник «Здоровье+»',
                    'about':
                    'Проводит лечение зубов с использованием микроскопа и цифровых технологий. Имеет большой опыт работы с осложнёнными клиническими случаями, включая перелечивание корневых каналов и восстановление разрушенных зубов. Постоянно внедряет новые методики для достижения идеального эстетического результата. Индивидуально подходит к каждому пациенту, подробно объясняет план лечения и варианты восстановления зубов.',
                  },
                ],
              ),

              ApplicationCard(
                title: "Консультация по установке брекетов",
                user: "Анна",
                datetime: "24.03.2025 10:15",
                doctor: "Ортодонт",
                description:
                "Хотела бы получить подробную консультацию по установке брекет-системы. Интересуют варианты металлических и керамических брекетов, ориентировочная стоимость, длительность лечения и процесс адаптации. Также хотелось бы обсудить, какие существуют современные альтернативы, например, элайнеры, и насколько они подходят в моём случае. Предпочтительно получить рекомендации по уходу за полостью рта во время ортодонтического лечения и планировать начало установки в ближайшие месяцы.",
                city: "Москва",
                cost: 0,
                urgent: false,
              ),


            ],
          ),
        ],
      ),
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

  Future<void> _openChangeCity() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeCityPage(
          selected: _controllers[3].text.isNotEmpty ? _controllers[3].text : null,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _controllers[3].text = result;
      });
    }
  }


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
                        minLines: 1,
                        maxLines: 12,
                        keyboardType: TextInputType.multiline,
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
                      GestureDetector(
                        onTap: _openChangeCity,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _controllers[3],
                            readOnly: true,
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
                              suffixIcon: const Icon(Icons.chevron_right, color: Color(0xFF9BA1A5)),
                            ),
                            style: const TextStyle(color: Color(0xFF1D1D1F)),
                          ),
                        ),
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
                        onPressed: _allFilled ? () {
                          Navigator.pop(context);
                          showCustomNotification(context, 'Заявка была успешно создана!');
                          // TODO: Логика создания заявки
                        } : null,
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

// ===================== POPUP для архивной заявки ======================
class HistoryApplicationPopup extends StatefulWidget {
  final List<String>? initialValues;
  final String? datetime;
  final List<dynamic> responder;
  final bool? hasRating;
  final String? rating;

  const HistoryApplicationPopup({
    super.key,
    this.initialValues,
    this.datetime,
    this.hasRating,
    this.rating,
    this.responder = const [],
  });

  @override
  _HistoryApplicationPopupState createState() => _HistoryApplicationPopupState();
}

class _HistoryApplicationPopupState extends State<HistoryApplicationPopup> {
  late final List<TextEditingController> _controllers;
  final bool _isEditing = false;


  final List<String> cities = ['Москва', 'Санкт-Петербург', 'Казань'];

  bool get _allFilled =>
      _controllers.every((c) =>
      c.text
          .trim()
          .isNotEmpty);

  @override
  void initState() {
    super.initState();
    final init = widget.initialValues ?? List<String>.filled(5, '');
    _controllers = List.generate(
        5, (i) => TextEditingController(text: init.length > i ? init[i] : ''));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
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

              // Верхняя панель: Назад и Изменить/Готово
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Назад",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      const url = 'https://t.me/suehsush';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      } else {
                        // Можно показать Snackbar или Alert
                        debugPrint('Не удалось открыть ссылку');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        "Поддержка",
                        style: TextStyle(
                          color: Colors.red.shade400, // тот же красный, что был
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Заголовок "Заявка"
              const Text(
                "Заявка",
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF1D1D1F),
                  fontWeight: FontWeight.w200,
                ),
              ),

              // Дата и время из widget.datetime
              if (widget.datetime != null)
                Text(
                  widget.datetime!,
                  style: const TextStyle(
                    fontSize: 32,
                    color: ApplicationCard._gray,
                    fontWeight: FontWeight.w200,
                  ),
                ),

              const SizedBox(height: 20),

              // Подзаголовок/описание
              const Text(
                "Здесь Вы можете посмотреть содержимое архивной заявки, а также удалить её.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ApplicationCard._label),
              ),

              const SizedBox(height: 60),


              Row(
                children: [
                  // Левая кнопка
                  Expanded(
                    child: SizedBox(
                      height: 61,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F6F7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // TODO: открыть чат
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/icons/chat.svg',
                                width: 18,
                                height: 20
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Посмотреть чат',
                              style: TextStyle(
                                color: ApplicationCard._label,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Правая кнопка
                  Expanded(
                    child: SizedBox(
                      height: 61,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFFE3B30)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final confirmed = await showConfirmationDialog(
                                context,
                                'Удалить заявку',
                                'Данная заявка будет полностью\n удалена из базы данных приложения.\n Врачи больше не смогут её посмотреть.',
                                'Удалить',
                                'Отмена',
                              );

                              if (confirmed) {
                                showCustomNotification(context, 'Заявка была успешно удалена');
                              //   TODO: Логика удаления заявки
                              }

                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/trash-red.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Удалить",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFE3B30),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Блок: Откликнувшиеся врачи с серым фоном всей области и радиусами у крайних элементов
              if (widget.responder.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text("Лечащий врач",
                        style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 12),

                // Фоновая панель для списка (цвет 0xFF9BA1A5)
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BA1A5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.responder.length,
                    separatorBuilder: (context, index) {
                      return widget.responder.length > 1 ? const _ThinDivider() : const SizedBox.shrink();
                    },
                    itemBuilder: (context, index) {
                      final responder = widget.responder[index];
                      final bool hasRating = widget.hasRating ?? false;
                      final String rating = widget.rating ?? '';
                      final String name = (responder['name'] ?? '') as String;
                      final String surname = (responder['surname'] ?? '') as String;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context, // 'context' здесь очень важен!
                            MaterialPageRoute(builder: (context) => ProfilePageFromUserPers(
                              isArchived: true,
                              name: responder['name'],
                              surname: responder['surname'],
                              specialization: responder['specialization'],
                              rating: responder['rating'],
                              applications_quant: responder['completed'],
                              phone_num: responder['phone'],
                              email: responder['email'],
                              city: responder['city'],
                              work_exp: responder['experience'],
                              services_cost: responder['price'],
                              work_place: responder['workplace'],
                              about: responder['about'],
                            )),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F6F7),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/userProfile.svg',
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surname,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D1D1F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF9BA1A5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (hasRating) ...[
                                const SizedBox(width: 20),
                                Container(
                                  width: 48,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/star.svg',
                                        width: 14,
                                        height: 13,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        rating,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFF4361),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(width: 20),
                              SvgPicture.asset(
                                'assets/images/icons/arrow_right.svg',
                                width: 7,
                                height: 12,
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],

              const SizedBox(height: 20),

              // Поля ввода
              // Поле 1: Врач
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Врач",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[0],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Стоматолог",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 2: Причина
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Причина",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[1],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Зубная боль",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 3: Подробное описание
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Подробное описание",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[2],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Опишите подробно проблему",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                minLines: 1,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 4: Город (Dropdown)
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Город",
                      style: TextStyle(color: Color(0xFF9BA1A5), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Text(
                  _controllers[3].text.isNotEmpty ? _controllers[3].text : 'Выберите город',
                  style: TextStyle(
                    color: _controllers[3].text.isNotEmpty ? const Color(0xFF1D1D1F) : const Color(0xFF9BA1A5),
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 12),

              // Поле 5: Предлагаемая стоимость
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Предлагаемая стоимость",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[4],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "9000р",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper-функция для показа попапа
Future<Map<String, dynamic>?> showHistoryApplicationPopup(
    BuildContext context, {
      List<String>? initialValues,
      String? datetime,
      List<dynamic> responder = const [],
      bool? hasRating,
      String? rating,
    }) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HistoryApplicationPopup(
      initialValues: initialValues,
      datetime: datetime,
      responder: responder,
      hasRating: hasRating,
      rating: rating,
    ),
  );
}

// ==================== POPUP для готовой заявки =======================

class ChangeApplicationPopup extends StatefulWidget {
  final List<String>? initialValues;
  final bool urgent;
  final String? datetime;
  final List<Map<String, dynamic>> responders;

  const ChangeApplicationPopup({
    super.key,
    this.initialValues,
    this.urgent = false,
    this.datetime,
    this.responders = const [],
  });

  @override
  _ChangeApplicationPopupState createState() => _ChangeApplicationPopupState();
}

class _ChangeApplicationPopupState extends State<ChangeApplicationPopup> {
  late final List<TextEditingController> _controllers;
  late bool _urgent;
  bool _isEditing = false;

  Future<void> _openChangeCity() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeCityPage(
          selected: _controllers[3].text.isNotEmpty ? _controllers[3].text : null,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _controllers[3].text = result;
      });
    }
  }
  final List<String> cities = ['Москва', 'Санкт-Петербург', 'Казань'];

  bool get _allFilled =>
      _controllers.every((c) =>
      c.text
          .trim()
          .isNotEmpty);

  @override
  void initState() {
    super.initState();
    _urgent = widget.urgent;
    final init = widget.initialValues ?? List<String>.filled(5, '');
    _controllers = List.generate(
        5, (i) => TextEditingController(text: init.length > i ? init[i] : ''));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
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

              // Верхняя панель: Назад и Изменить/Готово
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Назад",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_isEditing) {
                        // Входим в режим редактирования
                        setState(() => _isEditing = true);
                        return;
                      }

                      // Сейчас _isEditing == true — пользователь нажал "Готово"
                      // Собираем данные из контроллеров и передаём результат наружу
                      final result = {
                        'doctor': _controllers[0].text,
                        'reason': _controllers[1].text,
                        'description': _controllers[2].text,
                        'city': _controllers[3].text,
                        'cost': _controllers[4].text,
                        'urgent': _urgent,
                        'datetime': widget.datetime,
                      };

                      // Опционально: проверка заполненности
                      if (!_allFilled) {
                        showCustomNotification(context, 'Пожалуйста, заполните все поля!');
                        return;
                      }

                      Navigator.pop(context, result);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        _isEditing ? "Готово" : "Изменить",
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Заголовок "Заявка"
              const Text(
                "Заявка",
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF1D1D1F),
                  fontWeight: FontWeight.w200,
                ),
              ),

              // Дата и время из widget.datetime
              if (widget.datetime != null)
                Text(
                  widget.datetime!,
                  style: const TextStyle(
                    fontSize: 32,
                    color: ApplicationCard._gray,
                    fontWeight: FontWeight.w200,
                  ),
                ),

              const SizedBox(height: 20),

              // Подзаголовок/описание
              const Text(
                "Здесь Вы можете посмотреть и изменить содержимое, а также завершить заявку.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ApplicationCard._label),
              ),

              const SizedBox(height: 60),


              Row(
                children: [
                  // Левая кнопка
                  Expanded(
                    child: SizedBox(
                      height: 61,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F6F7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // TODO: открыть чат
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/icons/chat.svg',
                                width: 18,
                                height: 20
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Открыть чат',
                              style: TextStyle(
                                color: ApplicationCard._label,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Правая кнопка
                  Expanded(
                    child: SizedBox(
                      height: 61,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF0F3), // светло-розовый фон (под скрин)
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final confirmed = await showConfirmationDialog(
                            context,
                            'Завершить заявку',
                            'Данная заявка будет завершена\n и помещена в архив заявок профиля.\n Врачи больше не смогут её посмотреть.',
                            'Завершить',
                            'Отмена',
                          );

                          if (confirmed) {
                            showCustomNotification(context, 'Заявка была успешно завершена!');
                            //   TODO: Логика перенесения заявки в архив + отзыв
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/icons/checkmark.svg',
                                width: 20,
                                height: 20
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Завершить',
                              style: TextStyle(
                                color: Color(0xFFFF2D55),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Блок: Откликнувшиеся врачи с серым фоном всей области и радиусами у крайних элементов
              if (widget.responders.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text("Откликнувшиеся врачи",
                        style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 12),

                // Фоновая панель для списка (цвет 0xFF9BA1A5)
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BA1A5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.responders.length,
                    // separator ставим строго между элементами; если элементов <=1 будет пусто
                    separatorBuilder: (context, index) {
                      return widget.responders.length > 1 ? const _ThinDivider() : const SizedBox.shrink();
                    },
                    itemBuilder: (context, index) {
                      final responder = widget.responders[index];
                      final String name = (responder['name'] ?? '') as String;
                      final String surname = (responder['surname'] ?? '') as String;

                      // Рассчитываем радиусы в зависимости от позиции
                      final bool isFirst = index == 0;
                      final bool isLast = index == widget.responders.length - 1;
                      final BorderRadius itemRadius;
                      if (widget.responders.length == 1) {
                        itemRadius = BorderRadius.circular(10);
                      } else if (isFirst) {
                        itemRadius = const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        );
                      } else if (isLast) {
                        itemRadius = const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        );
                      } else {
                        itemRadius = BorderRadius.zero;
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context, // 'context' здесь очень важен!
                            MaterialPageRoute(builder: (context) => ProfilePageFromUserPers(
                              isArchived: false,
                              name: responder['name'],
                              surname: responder['surname'],
                              specialization: responder['specialization'],
                              rating: responder['rating'],
                              applications_quant: responder['completed'],
                              phone_num: responder['phone'],
                              email: responder['email'],
                              city: responder['city'],
                              work_exp: responder['experience'],
                              services_cost: responder['price'],
                              work_place: responder['workplace'],
                              about: responder['about'],
                              datetime: widget.datetime as String,
                            )), // Замените DoctorScreen() на ваш виджет
                          );
                        },
                        child: Container(
                          // Отдельный белый прямоугольник внутри серой панели,
                          // чтобы визуально совпадало со скрином; радиусы применяются к этому контейнеру
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F6F7),
                            borderRadius: itemRadius,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              // Серый кружок вместо фото
                              SvgPicture.asset(
                                  'assets/images/icons/userProfile.svg',
                                  width: 60,
                                  height: 60
                              ),

                              const SizedBox(width: 12),

                              // Фамилия сверху (bold), имя снизу (обычный)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surname,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D1D1F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF9BA1A5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Серый кружок вместо стрелки
                              SvgPicture.asset(
                                  'assets/images/icons/arrow_right.svg',
                                  width: 7,
                                  height: 12
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],


              // Поля ввода
              // Поле 1: Врач
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Врач",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[0],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Стоматолог",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 2: Причина
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Причина",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[1],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Зубная боль",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 3: Подробное описание
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Подробное описание",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[2],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "Опишите подробно проблему",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                minLines: 1,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Поле 4: Город (Dropdown)
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Город",
                      style: TextStyle(color: Color(0xFF9BA1A5), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              _isEditing
                  ? TextFormField(
                controller: _controllers[3],
                readOnly: true,
                onTap: _openChangeCity,
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
                  suffixIcon: const Icon(Icons.chevron_right, color: Color(0xFF9BA1A5)),
                ),
                style: const TextStyle(color: Color(0xFF1D1D1F)),
              )
                  : TextFormField(
                controller: _controllers[3],
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Выберите город",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(color: Color(0xFF1D1D1F)),
              ),
              const SizedBox(height: 12),

              // Поле 5: Предлагаемая стоимость
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Предлагаемая стоимость",
                      style: TextStyle(color: Color(0xFF677076), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[4],
                enabled: _isEditing,
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                decoration: InputDecoration(
                  hintText: "9000р",
                  hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 60),

              // Переключатель Срочно
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Срочно",
                      style: TextStyle(color: Color(0xFF9BA1A5), fontSize: 16)),
                  SizedBox(
                    width: 51,
                    height: 31,
                    child: Switch(
                      value: _urgent,
                      onChanged: _isEditing ? (val) =>
                          setState(() => _urgent = val) : null,
                      activeTrackColor: const Color(0xFF77D572),
                      inactiveTrackColor: const Color(0xFFE9E9EA),
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      trackOutlineColor: MaterialStateProperty.all(
                          Colors.transparent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper-функция для показа попапа
Future<Map<String, dynamic>?> showChangeApplicationPopup(
    BuildContext context, {
      List<String>? initialValues,
      bool urgent = false,
      String? datetime,
      List<Map<String, dynamic>> responders = const [],
    }) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChangeApplicationPopup(
      initialValues: initialValues,
      urgent: urgent,
      datetime: datetime,
      responders: responders,
    ),
  );
}

