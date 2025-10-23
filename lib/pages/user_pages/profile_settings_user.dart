import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/back_button.dart';

import '../../components/DividerLine.dart';
import '../../components/SettingsRow.dart';
import '../../components/custom_button.dart';
import '../../themes/AppColors.dart';

class SettingsPage extends StatefulWidget {
  final String appVersion;

  const SettingsPage({Key? key, this.appVersion = '1.02'}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currentLanguage = 'Русский';

  void _openPrivacyPolicy() {
    // Навигация на страницу политики конфиденциальности
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
    );
  }

  void _openMedicalDocument() {
    // Навигация на медицинский документ
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MedicalDocumentPage()),
    );
  }


  void _contactSupport() {
    // Пример: открыть почтовый клиент, чат, или перейти на страницу поддержки
    // Реализация зависит от вашей логики
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Связаться с поддержкой'),
        content: const Text('Открыть почту или чат поддержки.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(height: 1, thickness: 1);
    final sectionHeaderStyle = TextStyle(color: AppColors.grey600, fontSize: 13);

    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
        leadingWidth: 90,
        centerTitle: true,
        title: const Text('Настройки', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.background,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            DividerLine(),

            // Список настроек в Expanded
            Expanded(
              child: ListView(
                children: [
                  // Section: Основные документы
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'Основные документы',
                      style: sectionHeaderStyle,
                    ),
                  ),

                    Column(
                      children: [

                        DividerLine(),

                        SettingsRow(
                          title: 'Политика конфиденциальности',
                          onTap: _openMedicalDocument,
                          showArrow: true,
                        ),

                        DividerLine(),

                        SettingsRow(
                          title: 'Медицинский документ',
                          onTap: _openMedicalDocument,
                          showArrow: true,
                        ),

                        DividerLine(),
                      ],

                    ),






                  // Section: Язык интерфейса
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Изменить язык интерфейса',
                      style: sectionHeaderStyle,
                    ),
                  ),

                  Opacity(
                    opacity: 0.25, // 75% прозрачности
                    child: SettingsRow(
                      title: 'Язык',
                      trailing: Text(
                        _currentLanguage,
                        style: TextStyle(color: AppColors.grey600),
                      ),
                      showArrow: true,
                    ),
                  ),



                  // Contact support

                  DividerLine(),

                  const SizedBox(height: 28),

                  DividerLine(),
                      const CustomButton(
                        label: 'Связаться с поддержкой',
                        color: Colors.red,
                      ),

                  DividerLine(),

                ],
              ),
            ),

            // Версия приложения снизу
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Версия приложения',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appVersion,
                    style: const TextStyle(
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
      backgroundColor: AppColors.background,
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
