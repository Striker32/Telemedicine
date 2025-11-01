import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/custom_button.dart';
import 'package:last_telemedicine/components/display_rate_component.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/Appbar/CustomAppBar.dart';
import '../../components/Appbar/ProfileAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/SettingsRow.dart';
import '../../components/Appbar/AppBarButton.dart';
import '../../themes/AppColors.dart';
import '../user_pages/profile_settings_user.dart';
import '../user_pages/subpages/Change_city.dart';

class ProfilePageDoctor extends StatefulWidget {
  const ProfilePageDoctor({Key? key}) : super(key: key);

  @override
  State<ProfilePageDoctor> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageDoctor> {
  // Дизайн-токены (подгоняются под макет)
  static const Color kBackground = Color(0xFFEFEFF4); // цвет фона
  static const Color kPrimaryText = Color(0xFF111111); // цвет имени
  static const Color kSecondaryText = Color(
    0xFF9BA1A5,
  ); // цвет значения в контактных данных

  bool _isEditing = false;

  final TextEditingController _phoneController = TextEditingController(
    text: '+ 7 900 502 93',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'example@mail.ru',
  );

  final TextEditingController _nameController = TextEditingController(
    text: 'Георгий',
  );

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _specializationController = TextEditingController(
    text: 'Стоматолог',
  );

  final TextEditingController _experienceController = TextEditingController(
    text: '13 лет',
  );

  final TextEditingController _placeOfWorkController = TextEditingController(
    text: 'Городская больница №28',
  );

  final TextEditingController _priceController = TextEditingController(
    text: '3900 ₽',
  );

  final TextEditingController _aboutController = TextEditingController(
    text: 'Специализируюсь на лечении кариеса, пульпита, заболеваний дёсен,'
        ' а также проведении профессиональной гигиены полости рта'
        '  Помогаю пациентам сохранить здоровье зубов и красивую улыбку,'
        ' подбираю индивидуальный подход к каждому случаю  '
        'Провожу консультации онлайн и разрабатываю план лечения '
        'с учётом ваших потребностей ',
  );

  String _currentCity = 'Санкт-Петербург';

  void _changeCityFuncion() async {
    // Пример: открыть страницу выбора языка и ждать результата
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ChangeCityPage(selected: _currentCity)),
    );
    if (result != null && result != _currentCity) {
      setState(() => _currentCity = result);
      // Здесь можно вызвать сохранение в настройки/сервер
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: ProfileAppBar( // <-- 3. Используйте новый виджет
        title: 'Профиль',
        isEditing: _isEditing,
        onEdit: () {
          setState(() {
            _isEditing = true;
          });
        },
        onCancel: () {
          setState(() {
            _isEditing = false;
            // Можно добавить логику сброса изменений
          });
        },
        onDone: () {
          setState(() {
            _isEditing = false;
            // Логика сохранения
          });
        },
        onSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileSettingsPageUser(),
            ),
          );
        },
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
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/icons/userProfile.svg",
                            width: 60,
                            height: 60,
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

                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),

                  const DividerLine(),

                  // Поля информации — без иконок, с тонкими разделителями
                  SettingsRow(
                    viewTitle: 'Номер телефона',
                    editTitle: 'Изменить телефон' ,
                    controller: _phoneController,
                    isEditable: _isEditing,
                    controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  SettingsRow(
                      viewTitle: 'Почта',
                      editTitle: 'Изменить почту' ,
                      controller: _emailController,
                      isEditable: _isEditing,
                    controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: "Город",
                    editTitle: "Изменить город",
                    value: _currentCity,
                    onTap: _isEditing ? _changeCityFuncion : null,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 10),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Специализация',
                    editTitle: 'Изменить специализацию' ,
                    controller: _specializationController,
                    isEditable: _isEditing,
                    controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  SettingsRow(
                      viewTitle: 'Опыт',
                      editTitle: 'Изменить опыт' ,
                      controller: _experienceController,
                      isEditable: _isEditing,
                      controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Место работы',
                    editTitle: 'Изменить место работы' ,
                    controller: _placeOfWorkController,
                    isEditable: _isEditing,
                    controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 10),

                  const DividerLine(),

                  SettingsRow(
                    viewTitle: 'Стоимость от',
                    editTitle: 'Изменить стоимость услуг' ,
                    controller: _priceController,
                    isEditable: _isEditing,
                    controllerColor: AppColors.addLightText,
                  ),

                  const DividerLine(),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.white,
                    child: TextField(
                      controller: _aboutController,
                      readOnly: !_isEditing,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 16,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Кнопки действий
                  Column(
                    children: [
                      const SizedBox(height: 10),

                      const DividerLine(),

                      const CustomButton(label: 'Выйти', color: Colors.red),

                      const DividerLine(),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Для изменения логина'
                          '\nили пароля - обратитесь в поддержку',
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
