import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';

import '../../components/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/SettingsRow.dart';
import '../../components/AppBarButton.dart';
import '../../themes/AppColors.dart';

class ProfilePageDoctor extends StatefulWidget {
  const ProfilePageDoctor({Key? key}) : super(key: key);

  @override
  State<ProfilePageDoctor> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageDoctor> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kTitleColor = Color(0xFF111111); // цвет "Профиль"
  static const Color kLinkColor = Colors.red; // цвет "Настройки" и "Изменить"
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных
  static const Color kDivider = Color(0x3C3C43); // цвет разделителя

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: CustomAppBar(
        titleText: 'Профиль',
        leading: AppBarButton(label: 'Настройки', onTap: () {}),
        action: AppBarButton(label: 'Изменить', onTap: () {}),
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
                                  '+7 900 502 9229',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: kSecondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RatingBadge(
                            rating: '4,8',
                            subtitle: '23 заявки',
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
                  const SettingsRow(
                    title: 'Номер телефона',
                    value: '+7 900 502 9229',
                  ),

                  const DividerLine(),

                  const SettingsRow(title: 'Почта', value: 'example@mail.ru'),

                  const DividerLine(),

                  const SettingsRow(title: 'Город', value: 'Санкт-Петербург'),

                  const DividerLine(),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Работа',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const DividerLine(),

                  const SettingsRow(
                    title: 'Специализация',
                    value: 'Стоматолог',
                  ),

                  const DividerLine(),

                  const SettingsRow(title: 'Опыт', value: '13 лет'),

                  const DividerLine(),

                  const SettingsRow(
                    title: 'Место работы',
                    value: 'Городская больница №28',
                  ),

                  const DividerLine(),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Услуги',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const DividerLine(),

                  const SettingsRow(title: 'Стоимость от', value: '3900 ₽'),

                  const DividerLine(),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'О себе',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF677076),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.white,
                    child: Text(
                      'Внимание, Сталкер, приближается выброс, в укрытие!\n'
                          'Сертифицированный стоматолог с опытом работы более 13 лет'
                          '  Специализируюсь на лечении кариеса, пульпита, заболеваний дёсен,'
                          ' а также проведении профессиональной гигиены полости рта'
                          '  Помогаю пациентам сохранить здоровье зубов и красивую улыбку,'
                          ' подбираю индивидуальный подход к каждому случаю  '
                          'Провожу консультации онлайн и разрабатываю план лечения '
                          'с учётом ваших потребностей ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Кнопки действий
                  Column(
                    children: [
                      const SizedBox(height: 12),

                      const DividerLine(),

                      const CustomButton(label: 'Выйти', color: Colors.red),

                      const DividerLine(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Для изменения логина'
                              '\nили пароля - обратитесь в поддержку',
                          style: TextStyle(color: AppColors.grey600, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),


                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
