import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../components/Confirmation.dart';
import '../../components/Notification.dart';


class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: ApplicationCard._divider);
  }
}


// ЗАЯВКИ

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
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _text,
              ),
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



// POPUP ЗАЯВОК

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

