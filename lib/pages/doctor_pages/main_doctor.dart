import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../components/Application_for_feed.dart';
import '../../components/Loading.dart';
import '../../themes/AppColors.dart';
import '../user_pages/subpages/Change_city.dart';
import '../../auth/Fb_request_model.dart';
import '../../auth/Fb_user_model.dart';

class MainDoctor extends StatefulWidget {
  const MainDoctor({Key? key}) : super(key: key);

  @override
  _MainDoctorState createState() => _MainDoctorState();
}

class _MainDoctorState extends State<MainDoctor> {
  String? selectedCity;

  String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final repo = RequestRepository();

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFF4),
        appBar: CustomAppBar(
          titleText: 'Лента',
          leading: AppBarButton(label: '', onTap: () {}),
          action: AppBarButton(
            label: 'Локация',
            onTap: () async {
              final city = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => ChangeCityPage(selected: '')),
              );
              if (city != null) {
                setState(() => selectedCity = city);
              }
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // Активные заявки (status == '0')
                  StreamBuilder<List<RequestModel>>(
                    stream: repo.watchRequestsByStatus('0'),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: PulseLoadingWidget());
                      }

                      final items = snap.data ?? [];

                      // Фильтрация
                      final filteredItems =
                          (selectedCity != null &&
                              selectedCity!.isNotEmpty &&
                              selectedCity != 'Не выбран')
                          ? items.where((r) => r.city == selectedCity).toList()
                          : items;

                      // Пустое состояние — только центрированный текст
                      if (filteredItems.isEmpty) {
                        return const Center(child: Text("Нет объявлений"));
                      }

                      // Опциональные улучшения (рекомендации, не обязательны сейчас)
                      // Если список заявок может вырасти в будущем, используйте кэш в UserRepository: храните Map<uid, UserModel> и возвращайте cached или загружайте, чтобы не дергать сеть повторно при каждой сборке.

                      // Для мгновенной UX можно сначала показывать локальные заглушки для карточек, а затем заменять их уже полученными данными (но это потребует изменений в логике отображения).

                      // Если UserRepository.getUser может вернуть null, безопаснее сопоставлять пользователей по uid через Map, а не полагаться на порядок — но в вашей текущей структуре items и userFutures собираются в одном порядке, что проще и быстрее для MVP.

                      // Есть элементы — показываем заголовок как элемент списка и далее сами карточки
                      // Соберём все Future<UserModel> и дождёмся их разом, чтобы не запрашивать по одному при скролле
                      final userFutures = filteredItems
                          .map((r) => UserRepository().getUser(r.userUid))
                          .toList();

                      return FutureBuilder<List<UserModel>>(
                        future: Future.wait(userFutures),
                        builder: (context, usersSnap) {
                          if (usersSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: PulseLoadingWidget());
                          }

                          final users = usersSnap.data ?? [];

                          if (filteredItems.isEmpty) {
                            return Column(
                              children: const [
                                Center(
                                  child: Text(
                                    'Все объявления',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.mutedTitle,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: filteredItems.length + 1,
                            itemBuilder: (context, index) {
                              final r = filteredItems[index - 1];
                              final ts = r.updatedAt ?? r.createdAt;
                              final dtStr = ts != null ? _fmt(ts.toDate()) : '';

                              final fullName = users[index - 1];
                              final currentDoctorUid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final responded = r.hasResponded(
                                currentDoctorUid,
                              );

                              return ApplicationCard(
                                title: r.reason,
                                name: fullName.name,
                                surname: fullName.surname,
                                avatar: fullName.avatar,
                                datetime: dtStr,
                                doctor: r.specializationRequested,
                                description: r.description,
                                city: r.city,
                                cost: r.price,
                                urgent: r.urgent,
                                hasResponded: responded,
                                requestID: r.id,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// appBar: CustomAppBar(
// titleText: 'Лента',
// leading: AppBarButton(label: '', onTap: () {}),
// action: AppBarButton(label: 'Локация', onTap: () async {
// final selectedCity = await Navigator.push<String>(
// context,
// MaterialPageRoute(
// builder: (_) => ChangeCityPage(selected: ''),
// ),
// );
// }),
// ),
