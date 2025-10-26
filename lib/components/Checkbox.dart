import 'package:flutter/material.dart';

// 1. Меняем StatelessWidget на StatefulWidget
class Checkboxswitch extends StatefulWidget {
  const Checkboxswitch({super.key});

  @override
  // 2. Создаем состояние для нашего виджета
  State<Checkboxswitch> createState() => _Checkboxswitch();
}

// 3. Создаем класс состояния
class _Checkboxswitch extends State<Checkboxswitch> {
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
