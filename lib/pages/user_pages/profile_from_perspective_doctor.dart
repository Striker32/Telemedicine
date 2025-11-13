import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/Fb_request_model.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';
import 'package:last_telemedicine/pages/user_pages/applications_user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Services/Bottom_Navigator.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Confirmation.dart';
import '../../components/DividerLine.dart';
import '../../components/DoctorRespondButton.dart';
import '../../components/DoctorViewField.dart';
import '../../components/Notification.dart';
import '../../components/SettingsRow.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../components/pluralizeApplications.dart';
import '../../themes/AppColors.dart';

class ProfilePageFromUserPers extends StatefulWidget {
  final bool isArchived;
  final bool isActive;
  final String name;
  final String surname;
  final String specialization;
  final String rating;
  final String applications_quant;
  final String phone_num;
  final String email;
  final String city;
  final String work_exp;
  final String services_cost;
  final String work_place;
  final String about;
  final String datetime;
  final String requestID;
  final String id;

  const ProfilePageFromUserPers({
    Key? key,
    required this.isArchived,
    required this.isActive,
    required this.name,
    required this.requestID,
    required this.id,
    this.surname = '',
    this.specialization = 'Врач',
    this.rating = "-",
    this.applications_quant = '0',
    this.phone_num = '',
    this.email = '',
    this.city = '',
    this.work_exp = '',
    this.services_cost = '',
    this.work_place = '',
    this.about = '',
    this.datetime = '',
  }) : super(key: key);

  @override
  State<ProfilePageFromUserPers> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageFromUserPers> {
  late DatabaseReference _presenceRef;
  late Stream<DatabaseEvent> _presenceStream;
  bool _isOnline = false;
  Timestamp? _lastSeen;
  late final int quantity;

  // Дизайн-токены (подгоняются под макет)

  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных

  final repo = RequestRepository();

  @override
  void initState() {
    super.initState();
    quantity = int.tryParse(widget.applications_quant?.toString() ?? '') ?? 0;

    _presenceRef = FirebaseDatabase.instance.ref('presence/${widget.id}');
    _presenceStream = _presenceRef.onValue;

    _presenceStream.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _isOnline = data['online'] == true;
          _lastSeen = data['lastSeen'] != null
              ? Timestamp.fromMillisecondsSinceEpoch(data['lastSeen'])
              : null;
        });
      }
    });
  }

  String pluralizeMinutes(int minutes) {
    final mod10 = minutes % 10;
    final mod100 = minutes % 100;

    if (mod10 == 1 && mod100 != 11) return 'минута';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20))
      return 'минуты';
    return 'минут';
  }

  String _statusText(bool online, Timestamp? lastSeenAgo) {
    if (online) return 'в сети';
    if (lastSeenAgo == null) return 'был(-а) в сети давно';

    final seen = lastSeenAgo.toDate().toUtc();
    final diff = DateTime.now().toUtc().difference(seen);
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (minutes < 1) return 'был(-а) в сети только что';
    if (minutes < 2) return 'был(-а) в сети минуту назад';
    if (minutes < 5) return 'был(-а) в сети $minutes минуты назад';
    if (minutes <= 60) {
      final label = pluralizeMinutes(minutes);
      return 'был(-а) в сети $minutes $label назад';
    }
    if (hours < 24) return 'был(-а) в сети $hours часов назад';
    if (days == 1) return 'был(-а) в сети вчера';
    if (days == 2) return 'был(-а) в сети позавчера';
    if (days < 7) {
      final suffix = (days >= 2 && days <= 4) ? 'дня' : 'дней';
      return 'был(-а) в сети $days $suffix назад';
    }

    return 'был(-а) в сети давно';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        titleText: 'Информация',
        leading: AppBarButton(label: 'Назад'),
        action: AppBarButton(
          label: (widget.isActive || widget.isArchived) ? '' : 'Выбрать',
          onTap: () async {
            final confirmed = await showConfirmationDialog(
              context,
              'Выбрать врача',
              'Вы собираетесь выбрать данного\nврача Вашим основным лечащим врачом.\nпо заявке от ${widget.datetime}',
              'Выбрать',
              'Отмена',
            );

            if (confirmed) {
              if (confirmed) {
                await repo.assignDoctorAtomically(
                  requestId: widget.requestID,
                  doctorData: {'uid': widget.id},
                  select: true,
                  newStatus: '1', // назначен
                );
                Navigator.pop(context);
                Navigator.pop(context);
                showCustomNotification(
                  context,
                  'Вы успешно выбрали своего\nлечащего врача!',
                );
              }
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Блок аватара, имени и телефона
                  Container(
                    decoration: BoxDecoration(color: Colors.white),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/userProfile.svg',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.surname} ${widget.name}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryText,
                                  ),
                                ),
                                Text(
                                  _statusText(_isOnline, _lastSeen),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _isOnline
                                        ? AppColors.mainColor
                                        : AppColors.addLightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.rating != 0) ...{
                            RatingBadge(
                              rating: '${widget.rating}',
                              subtitle: '',
                              badgeColor: AppColors.additionalAccent,
                              badgeSize: 36,
                            ),
                          },
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 61,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFFFF0F3,
                                ), // светло-розовый фон (под скрин)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                // TODO: ннихуя
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/stethoscope.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.specialization}',
                                    style: TextStyle(
                                      color: Color(0xFFFF2D55),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: SizedBox(
                            height: 61,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF5F6F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                // TODO: нихуя
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/checkmark-black.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pluralizeApplications(quantity),
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Поля информации — без иконок, с тонкими разделителями
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Column(
                      children: [
                        FieldDoctorView(
                          title: 'Номер телефона',
                          mainText: widget.phone_num,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(title: 'Почта', mainText: widget.email),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(title: 'Город', mainText: widget.city),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(
                          title: 'Опыт работы',
                          mainText: widget.work_exp,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(
                          title: 'Услуги',
                          mainText: 'Стоимость от ${widget.services_cost}₽',
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(
                          title: 'Место работы',
                          mainText: widget.work_place,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const DividerLine(),
                        ),

                        FieldDoctorView(
                          title: 'О себе',
                          mainText: widget.about,
                          aboutself: true,
                        ),
                      ],
                    ),
                  ),

                  if (!widget.isArchived) ...{
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DoctorRespondedButton(
                        isActive: widget.isActive,
                        onTap: () async {
                          final confirmed = await showConfirmationDialog(
                            context,
                            'Выбрать врача',
                            'Вы собираетесь выбрать данного\nврача Вашим основным лечащим врачом.\nпо заявке от ${widget.datetime}',
                            'Выбрать',
                            'Отмена',
                          );

                          if (confirmed) {
                            widget.isActive
                                ? await repo.assignDoctorAtomically(
                                    requestId: widget.requestID,
                                    doctorData: {'uid': widget.id},
                                    remove: true, // назначен
                                  )
                                : await repo.assignDoctorAtomically(
                                    requestId: widget.requestID,
                                    doctorData: {'uid': widget.id},
                                    select: true,
                                    newStatus: '1', // назначен
                                  );
                            Navigator.pop(context);
                            Navigator.pop(context);
                            showCustomNotification(
                              context,
                              'Вы успешно выбрали своего\nлечащего врача!',
                            );
                          }
                        },
                        height: 60,
                      ),
                    ),
                  },

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
