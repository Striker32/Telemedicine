import 'package:flutter/material.dart';

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

  void _changeLanguage() async {
    // Пример: открыть страницу выбора языка и ждать результата
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguageSelectionPage(selected: _currentLanguage),
      ),
    );
    if (result != null && result != _currentLanguage) {
      setState(() => _currentLanguage = result);
      // Здесь можно вызвать сохранение в настройки/сервер
    }
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
    final sectionHeaderStyle = TextStyle(color: Colors.grey[600], fontSize: 13);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.red),
        centerTitle: true,
        title: const Text('Настройки', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFEFEFF4),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _SettingsTile(
                          text: 'Политика конфиденциальности',
                          onTap: _openPrivacyPolicy,
                        ),
                        divider,
                        _SettingsTile(
                          text: 'Медицинский документ',
                          onTap: _openMedicalDocument,
                        ),
                      ],
                    ),
                  ),

                  // Section: Язык интерфейса
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Изменить язык интерфейса',
                      style: sectionHeaderStyle,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _SettingsTile(
                      text: 'Язык',
                      trailing: Text(
                        _currentLanguage,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: _changeLanguage,
                    ),
                  ),

                  // Contact support
                  const SizedBox(height: 28),
                  Center(
                    child: TextButton(
                      onPressed: _contactSupport,
                      child: const Text(
                        'Связаться с поддержкой',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
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
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appVersion,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFEFEFF4),
    );
  }
}

/// Переиспользуемый виджет строки настройки
class _SettingsTile extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

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
class LanguageSelectionPage extends StatelessWidget {
  final String? selected;

  const LanguageSelectionPage({Key? key, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = ['Русский', 'English', 'Français'];
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите язык')),
      body: ListView.separated(
        itemCount: languages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final lang = languages[index];
          final isSelected = lang == selected;
          return ListTile(
            title: Text(lang),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () => Navigator.pop(context, lang),
          );
        },
      ),
    );
  }
}
