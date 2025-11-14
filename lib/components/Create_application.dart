import 'package:flutter/material.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/Notification.dart';
import '../auth/Fb_request_model.dart'; // <- модель заявки + репозиторий (RequestModel, RequestRepository)

// ================= POPUP СОЗДАНИЯ ЗАЯВКИ =================

class CreateApplicationPopup extends StatefulWidget {
  const CreateApplicationPopup({super.key});

  @override
  _CreateApplicationPopupState createState() => _CreateApplicationPopupState();
}

class _CreateApplicationPopupState extends State<CreateApplicationPopup> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  bool _urgent = false;

  // Репозиторий для сохранения заявки

  Future<void> _openChangeCity() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeCityPage(
          selected: _controllers[3].text.isNotEmpty
              ? _controllers[3].text
              : null,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _controllers[3].text = result;
      });
    }
  }

  bool get _allFilled => _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _createRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showCustomNotification(context, 'Сначала войдите в аккаунт');
      return;
    }

    // Собираем данные из полей
    final reason = _controllers[1].text.trim();
    final description = _controllers[2].text.trim();
    final city = _controllers[3].text.trim();
    final price = _controllers[4].text.trim();
    final specializationRequested = _controllers[0].text.trim();

    // Формируем модель заявки.
    // id будет сгенерирован в репозитории (createRequest возвращает id).
    final model = RequestModel(
      id: '', // временно пустой — createRequest сгенерирует id в репозитории
      userUid: user.uid,
      status: '0', // 0 = открыта
      doctors: [], // пока никого не назначено
      reason: reason,
      specializationRequested: specializationRequested,
      description: description,
      city: city,
      price: price,
      urgent: _urgent,
      createdAt: null,
      updatedAt: null,
      selectedDoctorUid: null,
    );

    final _repo = RequestRepository();

    try {
      final createdId = await _repo.createRequest(model);
      // успешно создана заявка
      Navigator.pop(context); // возвращаем id созданной заявки (опционально)
      showCustomNotification(context, 'Заявка успешно создана');
    } catch (e) {
      debugPrint('create request error: $e');
      showCustomNotification(context, 'Ошибка при создании заявки: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // отступ снизу равен высоте клавиатуры
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                        padding: EdgeInsets.only(
                          left: 16,
                        ), // небольшой отступ от краёв экрана
                        child: Text(
                          "Отменить",
                          style: TextStyle(color: Colors.red, fontSize: 16),
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
                    style: TextStyle(fontSize: 16, color: Color(0xFF1D1D1F)),
                  ),

                  const SizedBox(height: 50), // отступ после текста
                ],
              ),

              // Поля ввода
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Поле 1: врач / специализация
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 5,
                      ), // сдвиг надписи вправо
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Поле 2: причина
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 5,
                        top: 5,
                      ), // сдвиг надписи вправо
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
                      style: const TextStyle(color: Color(0xFF1D1D1F)),
                      decoration: InputDecoration(
                        hintText: "Зубная боль",
                        hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Поле 3: подробное описание
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 5,
                        top: 5,
                      ),
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
                      style: const TextStyle(color: Color(0xFF1D1D1F)),
                      decoration: InputDecoration(
                        hintText: "Опишите подробно проблему",
                        hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 12,
                      keyboardType: TextInputType.multiline,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Поле 4: город (выбор)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 5,
                        top: 5,
                      ),
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            suffixIcon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF9BA1A5),
                            ),
                          ),
                          style: const TextStyle(color: Color(0xFF1D1D1F)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Поле 5: предлагаемая стоимость
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 5,
                        top: 5,
                      ),
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
                      style: const TextStyle(color: Color(0xFF1D1D1F)),
                      decoration: InputDecoration(
                        hintText: "9000р",
                        hintStyle: const TextStyle(color: Color(0xFF9BA1A5)),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                            activeTrackColor: const Color(
                              0xFF77D572,
                            ), // фон включен
                            inactiveTrackColor: const Color(
                              0xFFE9E9EA,
                            ), // фон выключен
                            activeColor: Colors.white, // кружок включен
                            inactiveThumbColor: Colors.white, // кружок выключен
                            trackOutlineColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ), // убираем обводку
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Кнопка создать заявку
                    ElevatedButton(
                      onPressed: _allFilled
                          ? () async {
                              await _createRequest();
                            }
                          : null,
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0), // убираем тень
                        minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 57),
                        ), // высота кнопки
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(
                                  0xFFFFECF1,
                                ).withOpacity(0.5); // фон неактивной кнопки
                              }
                              return const Color(0xFFFFECF1); // активная кнопка
                            }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              14,
                            ), // закругление
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
                              : const Color(
                                  0xFFFF4361,
                                ).withOpacity(0.5), // неактивная
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
