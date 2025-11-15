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
                      ApplicationsEmptyView(),
                      HistoryApplicationsEmptyView(),
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

// ==================== Активные заявки =====================
class ApplicationsEmptyView extends StatefulWidget {
  const ApplicationsEmptyView({Key? key}) : super(key: key);

  @override
  _ApplicationsEmptyViewState createState() => _ApplicationsEmptyViewState();
}

class _ApplicationsEmptyViewState extends State<ApplicationsEmptyView> {
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
            debugPrint('DEBUG: snap? ${snap}');
            final active = items
                .where(
                  (r) =>
                      (r.status == '0' || r.status == '1') &&
                      r.userUid == firebaseUser.uid,
                )
                .toList();

            String _activeLabel(int count) {
              if (count == 0) return 'Нет заявок';

              final base = int.tryParse(count.toString()) != null
                  ? pluralizeApplications(count.toString())
                  : "Нет";

              final parts = base.split(' ');

              String adj;
              if (count % 10 == 1 && count % 100 != 11) {
                adj = 'активная';
              } else if (count % 10 >= 2 &&
                  count % 10 <= 4 &&
                  (count % 100 < 10 || count % 100 >= 20)) {
                adj = 'активные';
              } else {
                adj = 'активных';
              }

              return parts.length >= 2
                  ? '${parts.first} $adj ${parts.sublist(1).join(' ')}'
                  : '$base $adj';
            }

            if (active.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: availableHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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

            // --- Новый блок: загружаем всех докторов разом для active ---

            final doctorRepo = DoctorRepository();

            // Собираем все уникальные doctor uid, которые могут потребоваться:
            //  - selectedDoctorUid (если указан) и
            //  - все uid из r.doctorUids
            final allDoctorUids = <String>{};
            for (final r in active) {
              if (r.selectedDoctorUid != null &&
                  r.selectedDoctorUid!.isNotEmpty) {
                allDoctorUids.add(r.selectedDoctorUid!);
              }
              if (r.doctorUids != null && r.doctorUids.isNotEmpty) {
                allDoctorUids.addAll(r.doctorUids);
              }
            }

            // Если нет ни одного uid — можно сразу строить список (всегда пустые responders)
            if (allDoctorUids.isEmpty) {
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
                          urgent: r.urgent,
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            // Запрашиваем всех докторов одним вызовом
            return FutureBuilder<List<DoctorModel>>(
              future: doctorRepo.getDoctorsByUids(allDoctorUids.toList()),
              builder: (context, docSnap) {
                if (docSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: PulseLoadingWidget());
                }

                final doctorsList = docSnap.data ?? [];

                // Мапаем по uid для быстрого доступа
                final doctorsByUid = <String, DoctorModel>{};
                for (final d in doctorsList) {
                  doctorsByUid[d.uid] = d;
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

                          // Если выбран конкретный врач — возьмём его из мапы
                          if (r.selectedDoctorUid != null &&
                              r.selectedDoctorUid!.isNotEmpty) {
                            final d = doctorsByUid[r.selectedDoctorUid!];
                            if (d == null) {
                              // placeholder, если не нашли доктора
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: SizedBox(),
                              );
                            }

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
                          }

                          // Иначе собираем список резондеров по r.doctorUids
                          final doctorUids = r.doctorUids ?? [];
                          final responders = <Map<String, dynamic>>[];
                          for (final uid in doctorUids) {
                            final d = doctorsByUid[uid];
                            if (d != null) {
                              responders.add({
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
                              });
                            }
                          }

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
                      ),
                    ],
                  ),
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

class HistoryApplicationsEmptyView extends StatefulWidget {
  const HistoryApplicationsEmptyView({Key? key}) : super(key: key);

  @override
  _HistoryApplicationsEmptyViewState createState() =>
      _HistoryApplicationsEmptyViewState();
}

class _HistoryApplicationsEmptyViewState
    extends State<HistoryApplicationsEmptyView> {
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
            // фильтруем только статус == '2' и принадлежащие текущему пользователю
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

            // --- Новый блок: собираем все uid докторов из archived и загружаем их разом ---
            final doctorRepo = DoctorRepository();
            final allDoctorUids = <String>{};

            for (final r in archived) {
              if (r.selectedDoctorUid != null &&
                  r.selectedDoctorUid!.isNotEmpty) {
                allDoctorUids.add(r.selectedDoctorUid!);
              }
              if (r.doctorUids != null && r.doctorUids.isNotEmpty) {
                allDoctorUids.addAll(r.doctorUids);
              }
            }

            // Если нет ни одного uid, строим список без подгрузки докторов
            if (allDoctorUids.isEmpty) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      archived.isEmpty
                          ? 'Нет архивных заявок'
                          : '${archived.length} ${archived.length % 10 == 1 && archived.length % 100 != 11 ? "архивная заявка" : (archived.length % 10 >= 2 && archived.length % 10 <= 4 && (archived.length % 100 < 10 || archived.length % 100 >= 20) ? "архивные заявки" : "архивных заявок")}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: archived.length,
                      itemBuilder: (context, i) {
                        final r = archived[i];
                        String dtStr = '';
                        final ts = r.updatedAt ?? r.createdAt;
                        if (ts != null) dtStr = _fmt(ts.toDate());

                        // Без данных по врачам — показываем карточку без responder/physician
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
                          rating: r.rating,
                          responder: const [],
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            // Запрашиваем всех докторов одним вызовом
            return FutureBuilder<List<DoctorModel>>(
              future: doctorRepo.getDoctorsByUids(allDoctorUids.toList()),
              builder: (context, docSnap) {
                if (docSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: PulseLoadingWidget());
                }

                final doctorsList = docSnap.data ?? [];
                final doctorsByUid = <String, DoctorModel>{};
                for (final d in doctorsList) {
                  doctorsByUid[d.uid] = d;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        archived.isEmpty
                            ? 'Нет архивных заявок'
                            : '${archived.length} ${archived.length % 10 == 1 && archived.length % 100 != 11 ? "архивная заявка" : (archived.length % 10 >= 2 && archived.length % 10 <= 4 && (archived.length % 100 < 10 || archived.length % 100 >= 20) ? "архивные заявки" : "архивных заявок")}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: archived.length,
                        itemBuilder: (context, i) {
                          final r = archived[i];
                          String dtStr = '';
                          final ts = r.updatedAt ?? r.createdAt;
                          if (ts != null) dtStr = _fmt(ts.toDate());

                          // Если выбран конкретный врач — берём его из мапы
                          if (r.selectedDoctorUid != null &&
                              r.selectedDoctorUid!.isNotEmpty) {
                            final d = doctorsByUid[r.selectedDoctorUid!];
                            if (d == null) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: SizedBox(),
                              );
                            }

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
                              rating: r.rating,
                              responder: responders,
                            );
                          }

                          // Иначе собираем список responders по r.doctorUids
                          final doctorUids = r.doctorUids ?? [];
                          final responders = <Map<String, dynamic>>[];
                          for (final uid in doctorUids) {
                            final d = doctorsByUid[uid];
                            if (d != null) {
                              responders.add({
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
                              });
                            }
                          }

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
                            rating: r.rating,
                            responder: responders,
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
      },
    );
  }
}
