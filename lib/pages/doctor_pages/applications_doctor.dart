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
                title: "Острая боль в нижней челюсти при жевании",
                name: "Максим",
                surname: "Орлов",
                datetime: "12.04.2025 14:30",
                doctor: "Стоматолог",
                description:
                "Появилась резкая боль в нижнем зубе с левой стороны, особенно при жевании и попадании холодного воздуха. Сначала было лёгкое покалывание, теперь боль стала постоянной. Обезболивающие помогают ненадолго. Ранее подобных проблем не было. Требуется консультация стоматолога, желательно с рентгеном, чтобы определить причину — возможно, воспаление нерва или трещина корня.",
                city: "Москва",
                cost: 7200,
                rating: '5',
              ),

              HistoryApplicationCard(
                title: "Жжение и дискомфорт после долгого сидения",
                name: "Владимир",
                surname: "Селиванов",
                datetime: "05.02.2025 09:20",
                doctor: "Проктолог",
                description:
                "После долгого сидения за компьютером начал ощущать зуд и лёгкое жжение в области заднего прохода. Симптомы усиливаются вечером, особенно после рабочего дня. Никаких выделений или крови нет, но ощущается неприятное давление. Хотел бы пройти обследование у проктолога, чтобы исключить воспаление или начальную стадию геморроя. Проблема вызывает дискомфорт и мешает нормально работать.",
                city: "Москва",
                cost: 6500,
              ),

              HistoryApplicationCard(
                title: "Нечёткая дикция и трудности с произношением",
                name: "Илья",
                surname: "Трофимов",
                datetime: "08.03.2025 17:05",
                doctor: "Логопед",
                description:
                "После публичных выступлений заметил, что некоторые звуки произношу нечетко, особенно при быстрой речи. Есть ощущение напряжения в челюсти и языке. Ранее таких проблем не было. Хотелось бы пройти диагностику у логопеда, чтобы определить причину — возможно, это связано с неправильной артикуляцией или дыханием. Планирую заняться корректировкой речи и улучшить дикцию для уверенного общения.",
                city: "Москва",
                cost: 4800,
                rating: '3',
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
                title: "Острая боль в нижнем клыке",
                name: "Дмитрий",
                surname: "Петров",
                datetime: "15.04.2025 13:20",
                doctor: "Стоматолог",
                description:
                "Появилась сильная боль в нижнем клыке с правой стороны, особенно при накусывании и при попадании холодной пищи. Сначала была лёгкая чувствительность, теперь боль постоянная, иногда пульсирующая. Обезболивающие помогают ненадолго. Хотелось бы пройти осмотр и при необходимости лечение каналов зуба.",
                city: "Москва",
                cost: 7500,
                urgent: true,
              ),

              ApplicationCard(
                title: "Консультация по установке прозрачных элайнеров",
                name: "Екатерина",
                surname: "Иванова",
                datetime: "16.04.2025 09:45",
                doctor: "Ортодонт",
                description:
                "Хотела бы узнать про варианты лечения с помощью прозрачных элайнеров, сроки ношения и стоимость. Интересует, можно ли их комбинировать с профессиональной чисткой и отбеливанием. Также хочу понять, насколько комфортно носить элайнеры и какие есть ограничения по питанию и уходу за зубами. Жду подробной консультации и плана лечения.",
                city: "Санкт-Петербург",
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

