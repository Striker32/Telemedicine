import 'package:flutter/material.dart';

// 1. Меняем StatelessWidget на StatefulWidget
class Checkbox extends StatefulWidget {
  const Checkbox({super.key});

  @override
  // 2. Создаем состояние для нашего виджета
  State<Checkbox> createState() => _CheckboxState();
}

// 3. Создаем класс состояния
class _CheckboxState extends State<Checkbox> {
  // 4. Переносим изменяемую переменную сюда
  bool _urgent = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 51,
      height: 31,
      child: Switch(
        value: _urgent,
        // 5. Теперь setState будет работать корректно
        onChanged: (val) {
          setState(() {
            _urgent = val;
          });
        },
        activeTrackColor: const Color(0xFF77D572), // фон включен
        inactiveTrackColor: const Color(0xFFE9E9EA), // фон выключен
        activeColor: Colors.white, // кружок включен
        inactiveThumbColor: Colors.white, // кружок выключен
        trackOutlineColor: MaterialStateProperty.all(
          Colors.transparent,
        ), // убираем обводку
      ),
    );
  }
}
