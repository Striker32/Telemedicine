import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';

import '../../components/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/DoctorRespondButton.dart';
import '../../components/DoctorViewField.dart';
import '../../components/SettingsRow.dart';
import '../../components/AppBarButton.dart';
import '../../themes/AppColors.dart';

class ProfilePageFromUserPers extends StatefulWidget {
  //final bool isArchived;
  const ProfilePageFromUserPers({Key? key}) : super(key: key);

  @override
  State<ProfilePageFromUserPers> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageFromUserPers> {
  // Дизайн-токены (подгоняются под макет)

  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        titleText: 'Информация',
        leading: AppBarButton(label: 'Назад'),
        action: AppBarButton(label: 'Выбрать', onTap: () {}),
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1),
                        top: BorderSide(color: Colors.black12, width: 1),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFFE0E0E6),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                            // Для реальной аватарки: backgroundImage: AssetImage(...) / NetworkImage(...)
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Речнекова Мария Д.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryText,
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RatingBadge(
                            rating: '4,8',
                            subtitle: '',
                            badgeColor: AppColors.additionalAccent,
                            badgeSize: 36,
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Заголовок "Контактные данные"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Контактные данные',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const DividerLine(),

                  // Поля информации — без иконок, с тонкими разделителями
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 0),
                    child: Column(
                      children: [
                        const FieldDoctorView(
                          title: 'Номер телефона',
                          mainText: '+7 900 502 9229',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'Почта',
                          mainText: 'doctor@mail.ru',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'Город',
                          mainText: 'Санкт-Петербург',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'Опыт работы',
                          mainText: '13 лет опыта',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'Услуги',
                          mainText: 'Стоимость от 3000 ₽',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'Место работы',
                          mainText: 'Городская больница №28',
                        ),

                        const DividerLine(),

                        const FieldDoctorView(
                          title: 'О себе',
                          mainText: 'Внимание, Сталкер, приближается выброс, в укрытие!\n'
                              'Сертифицированный стоматолог с опытом работы более 13 лет'
                              '  Специализируюсь на лечении кариеса, пульпита, заболеваний дёсен,'
                              ' а также проведении профессиональной гигиены полости рта'
                              '  Помогаю пациентам сохранить здоровье зубов и красивую улыбку,'
                              ' подбираю индивидуальный подход к каждому случаю  '
                              'Провожу консультации онлайн и разрабатываю план лечения '
                              'с учётом ваших потребностей ',
                          aboutself: true,
                        ),


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,),
                    child: DoctorRespondedButton(onTap: () {  }, height: 60,),
                  ),

                  const SizedBox(height: 6,)




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
