import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/user_pages/profile_from_perspective_doctor.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../auth/Fb_doctor_model.dart';
import '../../auth/Fb_request_model.dart';
import '../../auth/Fb_user_model.dart';
import '../../components/Applcation_user.dart';
import '../../components/ApplicationHistory_user.dart';
import '../../components/Confirmation.dart';
import '../../components/Create_application.dart';
import '../../components/Loading.dart';
import '../../components/Notification.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../components/pluralizeApplications.dart';
import '../../themes/AppColors.dart';

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
                          children: [
                            const Center(
                              child: Text(
                                "Заявки",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        const CreateApplicationPopup(),
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

  String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return const Center(child: Text('Войдите, чтобы увидеть архив заявок'));
    }

    final repo = RequestRepository();
    final userRepo = UserRepository();

    return FutureBuilder<UserModel>(
      future: userRepo.getUser(firebaseUser.uid),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background2,
            body: const PulseLoadingWidget(),
          );
        }
        if (!userSnap.hasData) {
          return const Center(child: Text('Не удалось загрузить профиль'));
        }

        final u = userSnap.data!;
        final displayName = '${u.name}'.trim();

        return StreamBuilder<List<RequestModel>>(
          stream: repo.watchRequestsByUser(firebaseUser.uid),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: AppColors.background2,
                body: const PulseLoadingWidget(),
              );
            }
            final items = snap.data ?? [];
            // final items = [];
            // фильтруем только статус == '3'
            final archived = items
                .where((r) => r.status == '2' && r.userUid == firebaseUser.uid)
                .toList();

            if (archived.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : MediaQuery.of(context).size.height;

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),

                          const Center(
                            child: Text(
                              "Нет заявок",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Center(
                                child: const Text(
                                  'В данном разделе будут отображаться завершённые заявки.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${archived.length} архивных заявок',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: archived.length,
                    itemBuilder: (context, i) {
                      final r = archived[i];

                      String dtStr = '';
                      final ts = r.updatedAt ?? r.createdAt;
                      if (ts != null) {
                        dtStr = _fmt(ts.toDate());
                      }

                      final doctorRepo = DoctorRepository();

                      // если выбран врач
                      if (r.selectedDoctorUid != null &&
                          r.selectedDoctorUid!.isNotEmpty) {
                        return FutureBuilder<DoctorModel?>(
                          future: doctorRepo.getDoctor(r.selectedDoctorUid!),
                          builder: (context, docSnap) {
                            if (docSnap.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            final d = docSnap.data;
                            if (d == null) return const SizedBox.shrink();

                            final responders = [
                              {
                                'id': d.uid,
                                'name': d.name,
                                'surname': d.surname,
                                'avatar': d.avatar,
                                'rating':
                                    double.tryParse(d.rating.toString()) ?? 0.0,
                                'specialization': d.specialization,
                                'phone': d.phone,
                                'email': d.realEmail,
                                'city': d.city,
                                'experience': d.experience,
                                'price': d.price,
                                'workplace': d.placeOfWork,
                                'about': d.about,
                                'completed': d.completed,
                              },
                            ];

                            return HistoryApplicationCard(
                              title: r.reason,
                              user: displayName,
                              avatar: u.avatar,
                              datetime: dtStr,
                              doctor: r.specializationRequested,
                              description: r.description,
                              city: r.city,
                              cost: r.price,
                              requestID: r.id,
                              rating: d.rating,
                              responder:
                                  responders, // ← теперь список с одним врачом
                            );
                          },
                        );
                      }

                      // если selectedDoctorUid нет — можно оставить пусто или подгрузить всех
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

// ==================== Активные заявки =====================

class _ApplicationsEmptyView extends StatelessWidget {
  const _ApplicationsEmptyView();

  String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return const Center(child: Text('Войдите, чтобы увидеть ваши заявки'));
    }

    final repo = RequestRepository();
    final userRepo = UserRepository();

    return FutureBuilder<UserModel>(
      future: userRepo.getUser(firebaseUser.uid),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: PulseLoadingWidget());
        }
        if (!userSnap.hasData) {
          return const Center(child: Text('Не удалось загрузить профиль'));
        }

        final u = userSnap.data!;
        final displayName = '${u.name}'.trim();

        return StreamBuilder<List<RequestModel>>(
          stream: repo.watchRequestsByUser(firebaseUser.uid),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: PulseLoadingWidget());
            }

            final items = snap.data ?? [];
            // final items = [];
            final active = items
                .where(
                  (r) =>
                      (r.status == '0' || r.status == '1') &&
                      r.userUid == firebaseUser.uid,
                )
                .toList();

            String _activeLabel(int count) {
              if (count == 0) return 'Нет заявок';
              final base = pluralizeApplications(
                int.tryParse(count.toString())?.toString() ?? "Нет",
              );

              final parts = base.split(' ');
              return parts.length >= 2
                  ? '${parts.first} активных ${parts.sublist(1).join(' ')}'
                  : '$base активных';
            }

            if (active.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Используем фиксированную высоту равную видимой высоте контейнера,
                  // чтобы внутри можно было корректно центрировать без Expanded в SingleChildScrollView.
                  final availableHeight = constraints.maxHeight;

                  return SingleChildScrollView(
                    child: SizedBox(
                      height:
                          availableHeight, // гарантируем ограниченную высоту
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),

                          // счётчик (как был)
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

                          // кнопка остаётся вверху, не трогаем
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (context) =>
                                    const CreateApplicationPopup(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: AppColors.mainColor,
                                    size: 32,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Создать заявку",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Центрируем текст по вертикали и горизонтали внутри оставшегося пространства.
                          // Важно: сам Text и Padding не трогаем (они такие же, как у тебя).
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Center(
                                child: const Text(
                                  'В данном разделе Вы можете создать индивидуальную заявку и описать свою проблему, на которую откликнется нужный Вам врач.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return SingleChildScrollView(
              child: Column(
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: active.length,
                    itemBuilder: (context, i) {
                      final r = active[i];
                      final ts = r.updatedAt ?? r.createdAt;
                      final dtStr = ts != null ? _fmt(ts.toDate()) : '';
                      final doctorRepo = DoctorRepository();

                      if (r.selectedDoctorUid != null &&
                          r.selectedDoctorUid!.isNotEmpty) {
                        return FutureBuilder<DoctorModel?>(
                          future: doctorRepo.getDoctor(r.selectedDoctorUid!),
                          builder: (context, docSnap) {
                            if (docSnap.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
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
                            final d = docSnap.data;
                            if (d == null) return const SizedBox.shrink();
                            final physician = {
                              'id': d.uid,
                              'name': d.name,
                              'surname': d.surname,
                              'rating': d.rating,
                              'specialization': d.specialization,
                              'phone': d.phone,
                              'email': d.realEmail,
                              'city': d.city,
                              'experience': d.experience,
                              'price': d.price,
                              'workplace': d.placeOfWork,
                              'about': d.about,
                              'completed': d.completed,
                              'avatar': d.avatar,
                            };
                            return ApplicationCard(
                              title: r.reason,
                              user: displayName,
                              avatar: u.avatar,
                              datetime: dtStr,
                              doctor: r.specializationRequested,
                              description: r.description,
                              city: r.city,
                              cost: r.price,
                              requestID: r.id,
                              physician: physician,
                              urgent: r.urgent,
                            );
                          },
                        );
                      }

                      return FutureBuilder<List<DoctorModel>>(
                        future: doctorRepo.getDoctorsByUids(r.doctorUids),
                        builder: (context, docSnap) {
                          if (docSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
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
                          final doctors = docSnap.data ?? [];
                          final responders = doctors
                              .map(
                                (d) => {
                                  'id': d.uid,
                                  'name': d.name,
                                  'surname': d.surname,
                                  'avatar': d.avatar,
                                  'rating':
                                      double.tryParse(d.rating.toString()) ??
                                      0.0,
                                  'specialization': d.specialization,
                                  'phone': d.phone,
                                  'email': d.realEmail,
                                  'city': d.city,
                                  'experience': d.experience,
                                  'price': d.price,
                                  'workplace': d.placeOfWork,
                                  'about': d.about,
                                  'completed': d.completed,
                                },
                              )
                              .toList();

                          return ApplicationCard(
                            title: r.reason,
                            user: displayName,
                            avatar: u.avatar,
                            datetime: dtStr,
                            doctor: r.specializationRequested,
                            description: r.description,
                            city: r.city,
                            cost: r.price,
                            requestID: r.id,
                            responders: responders,
                            urgent: r.urgent,
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
      },
    );
  }
}
