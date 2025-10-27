import 'package:flutter/material.dart';
import '../../components/CustomAppBar.dart';
import '../../components/AppBarButton.dart';
import '../../components/Application_doctor.dart';
import '../user_pages/subpages/Change_city.dart';

class ApplicationsPageDoctor extends StatelessWidget {
  const ApplicationsPageDoctor({super.key});

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

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          //   child: Text(
          //     "В данном разделе хранятся Ваши архивные заявки, по которым Вы уже оказали помощь.",
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(fontSize: 13, color: Colors.black54),
          //   ),
          // ),

          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2),
            children: const [
              HistoryApplicationCard(
                title: "Стреляющая боль бокового верхнего резца",
                name: "Георгий",
                surname: "Медников",
                datetime: "23.03.2025 16:48",
                doctor: "Стоматолог",
                description:
                "Несколько дней мучает зубная боль. Сначала реагировал только на холодное и горячее, а сейчас болит постоянно и иногда отдаёт пульсирующей болью. Обезболивающие почти не помогают. Нужна консультация стоматолога, чтобы разобраться в причине и начать лечение",
                city: "Санкт-Петербург",
                cost: 8000,
                rating: '4',
                ),
              HistoryApplicationCard(
                title: "*окшгп* *уэугеээ* помогите",
                name: "Серега",
                surname: "Одуванчиков",
                datetime: "01.01.2025 11:48",
                doctor: "Проктолог",
                description:
                "Несколько дней мучает зубная боль. Сначала реагировал только на холодное и горячее, а сейчас болит постоянно и иногда отдаёт пульсирующей болью. Обезболивающие почти не помогают. Нужна консультация стоматолога, чтобы разобраться в причине и начать лечение",
                city: "Санкт-Петербург",
                cost: 8000,
                ),
              HistoryApplicationCard(
                title: "Эм ну я эм эм",
                name: "Алексей",
                surname: "Погребальный",
                datetime: "03.03.2025 04:00",
                doctor: "Логопед",
                description:
                "Несколько дней мучает зубная боль. Сначала реагировал только на холодное и горячее, а сейчас болит постоянно и иногда отдаёт пульсирующей болью. Обезболивающие почти не помогают. Нужна консультация стоматолога, чтобы разобраться в причине и начать лечение",
                city: "Санкт-Петербург",
                cost: 8000,
                rating: '2',
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

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          //   child: Text(
          //     "В данном разделе Вы можете отслеживать заявки на которые Вы откликнулись, а также просматривать их содержание и актуальный статус..",
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
                title: "Стреляющая боль бокового верхнего резца",
                name: "Георгий",
                surname: "Медников",
                datetime: "23.03.2025 16:48",
                doctor: "Стоматолог",
                description:
                "Несколько дней мучает зубная боль. Сначала реагировал только на холодное и горячее, а сейчас болит постоянно и иногда отдаёт пульсирующей болью. Обезболивающие почти не помогают. Нужна консультация стоматолога, чтобы разобраться в причине и начать лечение",
                city: "Санкт-Петербург",
                cost: 8000,
                urgent: true,
              ),
              ApplicationCard(
                title: "Консультация по брекетам",
                name: "Анна",
                surname: "Кононова",
                datetime: "24.03.2025 10:15",
                doctor: "Ортодонт",
                description: "Хотела бы узнать про установку брекетов. Плачу натурой.",
                city: "Москва",
                cost: 0,
                urgent: false,
                hasResponded: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

