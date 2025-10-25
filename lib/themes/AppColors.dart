// lib/theme/app_colors.dart
import 'package:flutter/material.dart';


/// Centralized color tokens for the app.
/// Комментарии указывают, в каких файлах эти цвета используются
/// на основе пришедших фрагментов кода (settings_page.dart, profile_page.dart,
/// components/custom_button.dart, components/InfoField.dart, components/DividerLine.dart).
///
/// Обновлено: добавлены цвета, которые явно использовались в коде, но не были
/// перечислены в первоначальной версии (например, Colors.black12, Colors.blue и т.д.).
///
/// Используйте: import 'package:your_app/theme/app_colors.dart';
/// и затем AppColors.background, AppColors.accentRed и т.д.


class AppColors {
// settings_page.dart — фон Scaffold и AppBar background
      // сдвиг по фазе

      static const Color background = Color(0xFFFBFCFD);

      static const Color addLightText = Color(0xFF9BA1A5);

      static const Color mainColor = Color(0xFFFF4361);

      static const Color additionalAccent = Color(0xFFFFECF1);



      static const Color black = Color(0xFF000000);

      static const Color white = Color(0xFFFFFFFF);



// settings_page.dart & profile_page.dart — акцентный красный (эквивалент Colors.red)
// используется для BackButton, ссылок и кнопок "Изменить"/"Настройки"
      static const Color accentRed = Color(0xFFF44336);


// components/custom_button.dart — светлый вариант red.shade200 (используется в CustomButton)
      static const Color accentRedLight = Color(0xFFFFCDD2);


// profile_page.dart — заголовки и основной текст (kTitleColor, kPrimaryText)
      static const Color primaryText = Color(0xFF111111);


// profile_page.dart — второстепенный текст (kSecondaryText)
      static const Color secondaryText = Color(0xFF9BA1A5);


// profile_page.dart — цвет заголовка 'Контактные данные' (именовался прямо в коде как 0xFF677076)
      static const Color mutedTitle = Color(0xFF677076);


// profile_page.dart — фон аватара
      static const Color avatarBg = Color(0xFFE0E0E6);


// Общие серые оттенки используемые в SettingsPage (Colors.grey[600], Colors.grey)
      static const Color grey600 = Color(0xFF757575); // Colors.grey[600]
      static const Color grey500 = Color(0xFF9E9E9E); // Colors.grey (default)
      static const Color grey200 = Color(0xFFEEEEEE); // Colors.grey.shade200 (часто используется в поверхностях)
      static const Color greyDivider = Color(0xFFD8D8D8);


// Разделители — profile_page.dart & components/DividerLine.dart
// Исходный код использовал `Color(0x3C3C43)` — без альфа; здесь приводим в 8-цифровой форме
      static const Color divider = Color(0xFF3C3C43);


// Карточки / поверхности
      static const Color surface = Color(0xFFFFFFFF); // эквивалент Colors.white


// Иконки Chevron и мелкие элементы
      static const Color icon = Color(0xFF9E9E9E);


// Дополнительные часто используемые цвета (не были в первом списке, но встречаются в коде)
// BorderSide(color: Colors.black12)
      static const Color black12 = Color(0x1F000000); // Colors.black12


// Используется в LanguageSelectionPage trailing Icon (Colors.blue)
      static const Color primaryBlue = Color(0xFF2196F3); // Colors.blue


// Базовые цвета

      // profile_settings_user.dart 'Связаться с поддержкой'
      static const Color red = Colors.red;
}