import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import 'Confirmation.dart';
import 'Notification.dart';

class ApplicationCard extends StatelessWidget {
  final String title;
  final String name;
  final String surname;
  final String datetime;
  final String doctor;
  final String description;
  final String city;
  final int cost;
  final bool urgent;
  final bool hasResponded;

  const ApplicationCard({
    Key? key,
    required this.title,
    required this.name,
    required this.surname,
    required this.datetime,
    required this.doctor,
    required this.description,
    required this.city,
    required this.cost,
    this.hasResponded = false,
    this.urgent = false,
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
              children: [
                // Иконка юзера
                SvgPicture.asset(
                  'assets/images/icons/userProfile.svg',
                  width: 60,
                  height: 60,
                ),

                const SizedBox(width: 15),

                // Имя + фамилия в колонке
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        surname,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9BA1A5),
                        ),
                      ),
                    ],
                  ),
                ),

                // Молния справа
                if (urgent)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SvgPicture.asset(
                      'assets/images/icons/lightning.svg',
                      width: 30,
                      height: 25,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Врач
            const SizedBox(height: 12),
            const Text("Ищу врача", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(doctor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Причина
            const SizedBox(height: 12),
            const Text("Причина", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

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

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Дата публикации
            const SizedBox(height: 12),
            const Text("Дата публикации", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 6),
            Text(datetime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 61,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: const Color(0xFFFFECF1),
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
                              name: name,
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
                                  'assets/images/icons/applications.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                "Открыть заявку",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFFF4361),
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
                    child: Opacity(
                      opacity: 0.5,
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
                              height: 20,
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








// POPUP

class ChangeApplicationPopup extends StatefulWidget {
  final List<String>? initialValues;
  final bool urgent;
  final String? datetime;
  final String? name;
  final bool hasResponded;

  const ChangeApplicationPopup({
    super.key,
    this.initialValues,
    this.urgent = false,
    this.datetime,
    this.name,
    this.hasResponded = false,
  });

  @override
  _ChangeApplicationPopupState createState() => _ChangeApplicationPopupState();
}

class _ChangeApplicationPopupState extends State<ChangeApplicationPopup> {
  late final List<TextEditingController> _controllers;
  late bool _urgent;
  bool _isEditing = false;
  final List<String> cities = ['Москва', 'Санкт-Петербург', 'Казань'];

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

              const SizedBox(height: 20),

              // Дата и время из widget.datetime
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/userProfile.svg',
                    width: 38,
                    height: 38,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.name ?? "Гость",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Подзаголовок/описание
              const Text(
                "Здесь Вы можете посмотреть содержимое заявки, а также откликнуться на неё.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ApplicationCard._label),
              ),

              const SizedBox(height: 60),


              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 61,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4361),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // TODO: завершить заявку
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/checkmark-white.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Пациент выбрал Вас',
                              style: TextStyle(
                                color: const Color(0xFFF5F5F7),
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
                                height: 20,
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


                ],
              ),



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
              DropdownButtonFormField<String>(
                value: _controllers[3].text.isNotEmpty
                    ? _controllers[3].text
                    : null,
                items: cities.map((city) => DropdownMenuItem<String>(
                  value: city,
                  child: Text(city, style: const TextStyle(color: Color(0xFF1D1D1F))),
                )).toList(),
                onChanged: _isEditing
                    ? (val) {
                  setState(() {
                    _controllers[3].text = val ?? '';
                  });
                }
                    : null,
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                dropdownColor: const Color(0xFFF5F5F5),
                menuMaxHeight: 200,
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
              const SizedBox(height: 20),

              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                ),
                onPressed: () async {
                    final confirmed = await showConfirmationDialog(
                      context,
                      'Убрать отклик',
                      'Вы собираетесь убрать и уведомить данного пациента об отзыве отклика по заявке ${widget.datetime}',
                      'Да',
                      'Отмена',
                    );

                    if (confirmed) {
                      Navigator.pop(context);
                      showCustomNotification(context, 'Вы успешно уведомили пациента об отзыве отклика по заявке!');
                      // TODO: убрать отклик на заявку
                    }
                },
                child: const Text(
                  'Убрать отклик',
                  style: TextStyle(
                    color: Color(0xFFFF4361),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              )

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
      String? name,
      bool hasResponded = false,
    }) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChangeApplicationPopup(
      initialValues: initialValues,
      urgent: urgent,
      datetime: datetime,
      name: name,
      hasResponded: hasResponded,
    ),
  );
}











// Заявки истории

class HistoryApplicationCard extends StatelessWidget {
  final String title;
  final String name;
  final String surname;
  final String datetime;
  final String doctor;
  final String description;
  final String city;
  final String rating;
  final int cost;

  const HistoryApplicationCard({
    Key? key,
    required this.title,
    required this.name,
    required this.surname,
    required this.datetime,
    required this.doctor,
    required this.description,
    required this.city,
    required this.cost,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Иконка юзера
                SvgPicture.asset(
                  'assets/images/icons/userProfile.svg',
                  width: 60,
                  height: 60,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        surname,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9BA1A5),
                        ),
                      ),
                    ],
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

            const SizedBox(height: 15),

            // Причина
            const SizedBox(height: 12),
            const Text("Причина", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

            const SizedBox(height: 12),
            const _ThinDivider(),

            // Дата публикации
            const SizedBox(height: 12),
            const Text("Дата публикации", style: TextStyle(fontSize: 12, color: _label)),
            const SizedBox(height: 6),
            Text(datetime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _text)),

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
                              hasRating: rating != '',
                              rating: rating,
                              name: name,
                              surname: surname,
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
                              'Данная заявка будет полностью удалена из базы данных приложения. Пациент больше не сможет её посмотреть.',
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




// POPUP истории

class HistoryApplicationPopup extends StatefulWidget {
  final List<String>? initialValues;
  final String? datetime;
  final List<dynamic> responder;
  final bool? hasRating;
  final String? rating;
  final String? name;
  final String? surname;

  const HistoryApplicationPopup({
    super.key,
    this.initialValues,
    this.datetime,
    this.hasRating,
    this.rating,
    this.name = "Гость",
    this.surname = "",
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

              const SizedBox(height: 20),

              // Дата и время из widget.datetime
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/userProfile.svg',
                    width: 38,
                    height: 38,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.name ?? "Гость",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Подзаголовок/описание
              const Text(
                "Здесь Вы можете посмотреть содержимое архивной заявки, а также удалить её.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ApplicationCard._label),
              ),

              const SizedBox(height: 20),

              if (widget.hasRating ?? false)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              widget.rating ?? "0",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFF4361),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Отзыв пациента',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF677076),
                        ),
                      ),
                    ],
                  ),
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
                                'Данная заявка будет полностью удалена из базы данных приложения. Пациент больше не сможет её посмотреть.',
                                'Удалить',
                                'Отмена',
                              );

                              if (confirmed) {
                                Navigator.pop(context);
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
              DropdownButtonFormField<String>(
                value: _controllers[3].text.isNotEmpty
                    ? _controllers[3].text
                    : null,
                items: cities.map((city) => DropdownMenuItem<String>(
                  value: city,
                  child: Text(city, style: const TextStyle(color: Color(0xFF1D1D1F))),
                )).toList(),
                onChanged: _isEditing
                    ? (val) {
                  setState(() {
                    _controllers[3].text = val ?? '';
                  });
                }
                    : null,
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(color: Color(0xFF1D1D1F)),
                dropdownColor: const Color(0xFFF5F5F5),
                menuMaxHeight: 200,
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
      String? name,
      String? surname,
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
      name: name,
      surname: surname,
    ),
  );
}