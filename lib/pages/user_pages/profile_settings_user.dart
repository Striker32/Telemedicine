import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/Appbar/AppBarButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/Appbar/CustomAppBar.dart';
import '../../components/DividerLine.dart';
import '../../components/SettingsRow.dart';
import '../../components/custom_button.dart';
import '../../themes/AppColors.dart';

class ProfileSettingsPageUser extends StatefulWidget {
  final String appVersion;

  const ProfileSettingsPageUser({Key? key, this.appVersion = '1.02'})
    : super(key: key);

  @override
  State<ProfileSettingsPageUser> createState() =>
      _ProfileSettingsPageUserState();
}

class _ProfileSettingsPageUserState extends State<ProfileSettingsPageUser> {
  String _currentLanguage = 'Русский';

  void _openPrivacyPolicy() {
    // Навигация на страницу политики конфиденциальности
    launchUrl(
      Uri.parse('https://02.rkn.gov.ru/directions/p4172/p18331/'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _openMedicalDocument() {
    // Навигация на медицинский документ
    launchUrl(
      Uri.parse(
        'https://www.it-lex.ru/usloviya_ispolzovaniya_servisa/polzovatelskoe_soglashenie',
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  // void _contactSupport() {
  //   // Пример: открыть почтовый клиент, чат, или перейти на страницу поддержки
  //   // Реализация зависит от вашей логики
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Связаться с поддержкой'),
  //       content: const Text('Открыть почту или чат поддержки.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Отмена'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('ОК'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final sectionHeaderStyle = TextStyle(
      color: AppColors.grey600,
      fontSize: 13,
    );

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Настройки', leading: AppBarButton()),
      body: SafeArea(
        child: Column(
          children: [
            // Список настроек в Expanded
            Expanded(
              child: ListView(
                children: [
                  // Section: Основные документы
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Text(
                      'Основные документы',
                      style: sectionHeaderStyle,
                    ),
                  ),

                  Column(
                    children: [
                      DividerLine(),

                      SettingsRow(
                        viewTitle: 'Политика обработки ПД',
                        onTap: _openPrivacyPolicy,
                        showArrow: true,
                      ),

                      DividerLine(),

                      SettingsRow(
                        viewTitle: 'Пользовательское соглашение',
                        onTap: _openMedicalDocument,
                        showArrow: true,
                      ),

                      DividerLine(),
                    ],
                  ),

                  // Section: Язык интерфейса
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Text(
                      'Изменить язык интерфейса',
                      style: sectionHeaderStyle,
                    ),
                  ),

                  Opacity(
                    opacity: 0.25, // 75% прозрачности
                    child: SettingsRow(
                      viewTitle: 'Язык',
                      trailing: Text(
                        _currentLanguage,
                        style: TextStyle(color: AppColors.grey600),
                      ),
                      showArrow: true,
                    ),
                  ),

                  // Contact support
                  const SizedBox(height: 30),

                  DividerLine(),
                  const CustomButton(
                    label: 'Связаться с поддержкой',
                    color: AppColors.mainColor,
                  ),

                  DividerLine(),
                ],
              ),
            ),

            // Версия приложения снизу
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Версия приложения',
                    style: TextStyle(color: AppColors.grey600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appVersion,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background2,
    );
  }
}

/// Переиспользуемый виджет строки настройки

/// Заглушка: страница политики конфиденциальности
class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Политика конфиденциальности')),
      body: const Center(child: Text('Текст политики')),
    );
  }
}

/// Заглушка: медицинский документ
class MedicalDocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Медицинский документ')),
      body: const Center(child: Text('Мед. документ')),
    );
  }
}

/// Страница выбора языка (возвращает выбранный язык через Navigator.pop)
// class LanguageSelectionPage extends StatelessWidget {
//   final String? selected;
//
//   const LanguageSelectionPage({Key? key, this.selected}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final languages = ['Русский', 'English', 'Français'];
//     return Scaffold(
//       appBar: AppBar(title: const Text('Выберите язык')),
//       body: ListView.separated(
//         itemCount: languages.length,
//         separatorBuilder: (_, __) => const Divider(height: 1),
//         itemBuilder: (context, index) {
//           final lang = languages[index];
//           final isSelected = lang == selected;
//           return ListTile(
//             title: Text(lang),
//             trailing: isSelected
//                 ? const Icon(Icons.check, color: AppColors.primaryBlue)
//                 : null,
//             onTap: () => Navigator.pop(context, lang),
//           );
//         },
//       ),
//     );
//   }
// }
