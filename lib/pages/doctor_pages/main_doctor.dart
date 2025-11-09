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

class MainDoctor extends StatelessWidget {
  const MainDoctor({super.key});

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
          action: AppBarButton(label: 'Локация', onTap: () async {
            final selectedCity = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeCityPage(selected: ''),
              ),
            );
          }),
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

                      // Пустое состояние — только центрированный текст
                      if (items.isEmpty) {
                        return const Center(child: Text("Нет объявлений"));
                      }

                      // Есть элементы — показываем заголовок как элемент списка и далее сами карточки
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: items.length + 1, // +1 для заголовка "Все объявления"
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Заголовок и отступ — это первый элемент списка, поэтому он прокручивается вместе с остальным
                            return Column(
                              children: const [
                                // SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Все объявления',
                                    style: TextStyle(fontSize: 12, color: AppColors.mutedTitle),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }

                          final r = items[index - 1];
                          final ts = r.updatedAt ?? r.createdAt;
                          final dtStr = ts != null ? _fmt(ts.toDate()) : '';

                          return FutureBuilder<UserModel>(
                            future: UserRepository().getUser(r.userUid),
                            builder: (context, userSnap) {
                              if (userSnap.connectionState == ConnectionState.waiting) {
                                // Небольшой placeholder вместо PulseLoadingWidget
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: SizedBox(
                                    height: 80,
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final fullName = userSnap.data!;
                              final currentDoctorUid = FirebaseAuth.instance.currentUser!.uid;
                              final responded = r.hasResponded(currentDoctorUid);

                              return ApplicationCard(
                                title: r.reason,
                                name: fullName.name,
                                surname: fullName.surname,
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
