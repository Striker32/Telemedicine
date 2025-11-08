import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../components/Applcation_user.dart';
import '../../components/ApplicationHistory_user.dart';
import '../../components/Confirmation.dart';
import '../../components/Create_application.dart';
import '../../components/Notification.dart';






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
                    'city': 'Каргополь',
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


