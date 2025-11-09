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
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data ?? [];
        final active = items.where((r) => r.hasResponded(doctor.uid) && !r.isArchived).toList();

        if (active.isEmpty) {
          return const Center(child: Text("0 активных заявок"));
        }

        return ListView.builder(
          itemCount: active.length,
          itemBuilder: (context, i) {
            final r = active[i];
            final ts = r.updatedAt ?? r.createdAt;
            final dtStr = ts != null ? _fmt(ts.toDate()) : '';

            return FutureBuilder<UserModel>(
              future: UserRepository().getUser(r.userUid),
              builder: (context, userSnap) {
                if (userSnap.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // или индикатор
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
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data ?? [];
        final archived = items.where((r) => r.hasResponded(doctor.uid)).toList();

        if (archived.isEmpty) {
          return const Center(child: Text("0 архивных заявок"));
        }

        return ListView.builder(
          itemCount: archived.length,
          itemBuilder: (context, i) {
            final r = archived[i];
            final ts = r.updatedAt ?? r.createdAt;
            final dtStr = ts != null ? _fmt(ts.toDate()) : '';


            return FutureBuilder<UserModel>(
              future: UserRepository().getUser(r.userUid),
              builder: (context, userSnap) {
                if (userSnap.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // или индикатор
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
                  rating: '—',
                );
              },
            );
          }
        );
      },
    );
  }
}
