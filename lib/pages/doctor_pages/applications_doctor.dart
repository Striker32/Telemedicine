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
                                  SizedBox(width: 105, child: Tab(text: "Активные")),
                                  SizedBox(width: 105, child: Tab(text: "Архив")),
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
                    _ActiveApplicationsView(),
                    _ArchivedApplicationsView(),
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
class _ActiveApplicationsView extends StatelessWidget {
  const _ActiveApplicationsView();

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
        final active = items.where((r) => r.hasResponded(doctor.uid) && !r.isArchived).toList();

        String _activeLabel(int count) {
          if (count == 0) return 'Нет заявок';
          return pluralizeApplications(count);
        }



        // Верхний блок: отступ + текст с количеством заявок
        // Если нет активных заявок — покажем центр с сообщением "тут будут заявки"
        if (active.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _activeLabel(active.length),
                    style: const TextStyle(fontSize: 12, color: AppColors.mutedTitle),
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
                        style: TextStyle(fontSize: 14, color: AppColors.primaryText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Есть активные заявки — рендерим список с заголовком сверху
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child: Text(
                  _activeLabel(active.length),
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedTitle),
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(height: 5)
              // Сам список — ListView.builder внутри Column: shrinkWrap и не скроллить отдельно
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: active.length,
                itemBuilder: (context, i) {
                  final r = active[i];
                  final ts = r.updatedAt ?? r.createdAt;
                  final dtStr = ts != null ? _fmt(ts.toDate()) : '';

                  return FutureBuilder<UserModel>(
                    future: UserRepository().getUser(r.userUid),
                    builder: (context, userSnap) {
                      if (userSnap.connectionState == ConnectionState.waiting) {
                        // Небольшой placeholder вместо Scaffold (сохраняет структуру списка)
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                            height: 80,
                            child: Center(child: SizedBox(width: 48, height: 48, child: PulseLoadingWidget())),
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
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= История заявок =================
class _ArchivedApplicationsView extends StatelessWidget {
  const _ArchivedApplicationsView();

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
        final archived = items.where((r) => r.hasResponded(doctor.uid)).toList();

        String _archiveLabel(int count) {
          if (count == 0) return 'Нет заявок';
          return pluralizeApplications(count);
        }

        // Пустое состояние: показываем заголовок и центральное сообщение
        if (archived.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _archiveLabel(archived.length),
                    style: const TextStyle(fontSize: 12, color: AppColors.mutedTitle),
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
                        style: TextStyle(fontSize: 14, color: AppColors.primaryText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Есть архивные заявки — рендерим заголовок и список
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child: Text(
                  _archiveLabel(archived.length),
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedTitle),
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

                  return FutureBuilder<UserModel>(
                    future: UserRepository().getUser(r.userUid),
                    builder: (context, userSnap) {
                      if (userSnap.connectionState == ConnectionState.waiting) {
                        // placeholder вместо Scaffold — чтобы не ломать список
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                            height: 80,
                            child: Center(child: SizedBox(width: 48, height: 48, child: PulseLoadingWidget())),
                          ),
                        );
                      }

                      final fullName = userSnap.data!;
                      return HistoryApplicationCard(
                        title: r.reason,
                        name: fullName.name,
                        surname: fullName.surname,
                        datetime: dtStr,
                        doctor: r.specializationRequested,
                        description: r.description,
                        city: r.city,
                        cost: r.price,
                        rating: '5',
                        requestID: r.id,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
