// У всех межбуквенный интервал -0.4px
// У всех шрифт SF Pro Display
// themes/TelemedicineTheme.dart

import 'package:flutter/material.dart';

// Создаем переменную, которая будет хранить нашу кастомную тему
final ThemeData appTheme = _buildAppTheme();

// Приватная функция для построения темы, чтобы инкапсулировать логику
ThemeData _buildAppTheme() {
  // За основу берем стандартную светлую тему
  final ThemeData base = ThemeData.light();

  // Возвращаем копию базовой темы с нашими кастомизациями
  return base.copyWith(
    textTheme: _buildAppTextTheme(base.textTheme),
  );
}

// Отдельная функция для настройки стилей текста
// Это делает код еще чище
TextTheme _buildAppTextTheme(TextTheme base) {
  const String fontName = 'SF Pro Display';
  const double letterSpacing = -0.4;

  // Применяем fontFamily и letterSpacing ко всем стилям текста
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    displayMedium: base.displayMedium?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    displaySmall: base.displaySmall?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    headlineLarge: base.headlineLarge?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    headlineMedium: base.headlineMedium?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    titleLarge: base.titleLarge?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    titleMedium: base.titleMedium?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    titleSmall: base.titleSmall?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    bodySmall: base.bodySmall?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    labelLarge: base.labelLarge?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    labelMedium: base.labelMedium?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
    labelSmall: base.labelSmall?.copyWith(fontFamily: fontName, letterSpacing: letterSpacing),
  ).apply( // Применяем базовые цвета текста, чтобы ничего не сломалось
    bodyColor: Colors.black, // Основной цвет текста
    displayColor: Colors.black, // Цвет для заголовков
  );
}

