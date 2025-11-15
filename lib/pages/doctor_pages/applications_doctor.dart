import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/DividerLine.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../components/ApplicationHistory_doctor.dart';
import '../../components/Application_doctor.dart';
import '../../auth/Fb_request_model.dart';
import '../../auth/Fb_user_model.dart';
import '../../components/Loading.dart';
import '../../components/pluralizeApplications.dart';
import '../../themes/AppColors.dart';

class ApplicationsPageDoctor extends StatelessWidget {
  const ApplicationsPageDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFF4),
        body: SafeArea(
          child: Column(
            children: [
              // Верхняя панель
              Container(
                width: double.infinity,
                color: const Color(0xFFFBFCFD),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 36,
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Center(
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
                    ActiveApplicationsView(),
                    ArchivedApplicationsView(),
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

// ==================== Активные заявки =====================
class ActiveApplicationsView extends StatefulWidget {
  const ActiveApplicationsView({Key? key}) : super(key: key);

  @override
  _ActiveApplicationsViewState createState() => _ActiveApplicationsViewState();
}

class _ActiveApplicationsViewState extends State<ActiveApplicationsView> {
  String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //       child: Column(
  //           children: [
  //           const SizedBox(height: 10),
  //       const Text(
  //         "2 активных заявки",
  //         style: TextStyle(fontSize: 12, color: Colors.black54),
  //       ),
  //       const SizedBox(height: 0),

  @override
  Widget build(BuildContext context) {
    final doctor = FirebaseAuth.instance.currentUser;
    if (doctor == null) {
      return const Center(child: Text('Войдите, чтобы увидеть заявки'));
    }

    final repo = RequestRepository();

    return StreamBuilder<List<RequestModel>>(
      stream: repo.watchRequestsByStatus('1'), // открытые
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background2,
            body: const PulseLoadingWidget(),
          );
        }
        final items = snap.data ?? [];

        // Фильтруем активные заявки как раньше
        final active = items
            .where((r) => r.hasResponded(doctor.uid) && !r.isArchived)
            .toList();

        // Если нет активных заявок — прежнее поведение (без изменений)
        String _activeLabel(int count) {
          if (count == 0) return 'Нет заявок';
          return pluralizeApplications(
            int.tryParse(count.toString())?.toString() ?? "Нет",
          );
        }

        if (active.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _activeLabel(active.length),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedTitle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: const Text(
                        'В данном разделе Вы можете отслеживать заявки на которые Вы откликнулись, а также просматривать их содержание и актуальный статус.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // --- Новый блок: загружаем всех пользователей разом для активных заявок ---

        // Собираем уникальные uid, чтобы не запрашивать одного пользователя несколько раз
        final uids = <String>{};
        for (final r in active) {
          uids.add(r.userUid);
        }

        // Создаём список futures для уникальных uid
        final userFuturesMap = <String, Future<UserModel?>>{};
        for (final uid in uids) {
          userFuturesMap[uid] = UserRepository().getUser(uid);
        }

        // Ждём всех UserModel параллельно
        return FutureBuilder<List<MapEntry<String, UserModel?>>>(
          future: Future.wait(
            userFuturesMap.entries.map((e) async {
              final user = await e.value;
              return MapEntry(e.key, user);
            }).toList(),
          ),
          builder: (context, usersSnap) {
            if (usersSnap.connectionState == ConnectionState.waiting) {
              // Показываем общий индикатор загрузки, сохраняя прежнюю структуру страницы
              return Scaffold(
                backgroundColor: AppColors.background2,
                body: const Center(child: PulseLoadingWidget()),
              );
            }

            // Собираем map uid -> UserModel? для быстрого доступа по userUid
            final usersList = usersSnap.data ?? [];
            final usersByUid = <String, UserModel?>{};
            for (final e in usersList) {
              usersByUid[e.key] = e.value;
            }

            // Строим ту же страницу + список, но уже синхронно получая user из usersByUid
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      _activeLabel(active.length),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedTitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: active.length,
                    itemBuilder: (context, i) {
                      final r = active[i];
                      final ts = r.updatedAt ?? r.createdAt;
                      final dtStr = ts != null ? _fmt(ts.toDate()) : '';

                      final fullName = usersByUid[r.userUid];

                      // Если пользователь не найден (null) — показываем пустую карточку или placeholder
                      if (fullName == null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                            height: 80,
                            child: Center(
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: PulseLoadingWidget(),
                              ),
                            ),
                          ),
                        );
                      }

                      final currentDoctorUid =
                          FirebaseAuth.instance.currentUser!.uid;
                      final responded = r.hasResponded(currentDoctorUid);

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
                        userID: r.userUid,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ================= История заявок =================
class ArchivedApplicationsView extends StatefulWidget {
  const ArchivedApplicationsView({Key? key}) : super(key: key);

  @override
  _ArchivedApplicationsViewState createState() =>
      _ArchivedApplicationsViewState();
}

class _ArchivedApplicationsViewState extends State<ArchivedApplicationsView> {
  String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  @override
  Widget build(BuildContext context) {
    final doctor = FirebaseAuth.instance.currentUser;
    if (doctor == null) {
      return const Center(child: Text('Войдите, чтобы увидеть архив'));
    }

    final repo = RequestRepository();

    return StreamBuilder<List<RequestModel>>(
      stream: repo.watchRequestsByStatus('2'), // архивные
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background2,
            body: const PulseLoadingWidget(),
          );
        }

        final items = snap.data ?? [];
        final archived = items
            .where((r) => r.hasResponded(doctor.uid))
            .toList();

        String _archiveLabel(int count) {
          if (count == 0) return 'Нет заявок';
          return pluralizeApplications(
            int.tryParse(count.toString())?.toString() ?? "Нет",
          );
        }

        if (archived.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _archiveLabel(archived.length),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedTitle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: const Text(
                        'В данном разделе хранятся Ваши архивные заявки, по которым Вы уже оказали помощь.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // --- Новый блок: загружаем всех users разом для archived ---

        // Сделаем de-dup uid, чтобы не запрашивать одного пользователя несколько раз
        final uids = <String>{};
        for (final r in archived) {
          uids.add(r.userUid);
        }

        // Собираем futures по уникальным uid
        final userFuturesMap = <String, Future<UserModel?>>{};
        for (final uid in uids) {
          userFuturesMap[uid] = UserRepository().getUser(uid);
        }

        // Ждём всех пользователей параллельно и мапим результат по uid
        return FutureBuilder<List<MapEntry<String, UserModel?>>>(
          future: Future.wait(
            userFuturesMap.entries.map((e) async {
              final user = await e.value;
              return MapEntry(e.key, user);
            }).toList(),
          ),
          builder: (context, usersSnap) {
            if (usersSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: AppColors.background2,
                body: const PulseLoadingWidget(),
              );
            }

            final usersList = usersSnap.data ?? [];
            final usersByUid = <String, UserModel?>{};
            for (final e in usersList) {
              usersByUid[e.key] = e.value;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      _archiveLabel(archived.length),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedTitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: archived.length,
                    itemBuilder: (context, i) {
                      final r = archived[i];
                      final ts = r.updatedAt ?? r.createdAt;
                      final dtStr = ts != null ? _fmt(ts.toDate()) : '';

                      final fullName = usersByUid[r.userUid];

                      if (fullName == null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                            height: 80,
                            child: Center(
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: PulseLoadingWidget(),
                              ),
                            ),
                          ),
                        );
                      }

                      return HistoryApplicationCard(
                        title: r.reason,
                        name: fullName.name,
                        surname: fullName.surname,
                        avatar: fullName.avatar,
                        datetime: dtStr,
                        doctor: r.specializationRequested,
                        description: r.description,
                        city: r.city,
                        cost: r.price,
                        rating: r.rating,
                        requestID: r.id,
                        userID: r.userUid,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
