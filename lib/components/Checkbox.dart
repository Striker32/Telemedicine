import 'package:flutter/material.dart';

class Checkboxswitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const Checkboxswitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<Checkboxswitch> createState() => _CheckboxswitchState();
}

class _CheckboxswitchState extends State<Checkboxswitch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 51,
      height: 31,
      child: Switch(
        value: widget.value,
        onChanged: widget.onChanged,
        activeTrackColor: const Color(0xFF77D572),
        inactiveTrackColor: const Color(0xFFE9E9EA),
        activeColor: Colors.white,
        inactiveThumbColor: Colors.white,
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}

