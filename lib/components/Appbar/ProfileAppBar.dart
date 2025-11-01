import 'package:flutter/material.dart';

import 'AppBarButton.dart';
import 'CustomAppBar.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isEditing;
  final VoidCallback onEdit; // Что делать при нажатии "Изменить"
  final VoidCallback onCancel; // Что делать при нажатии "Отмена"
  final VoidCallback onDone;   // Что делать при нажатии "Готово"
  final VoidCallback onSettings; // Что делать при нажатии "Настройки"

  const ProfileAppBar({
    Key? key,
    required this.title,
    required this.isEditing,
    required this.onEdit,
    required this.onCancel,
    required this.onDone,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      // AppBar для режима редактирования
      return CustomAppBar(
        titleText: title,
        leading: AppBarButton(
          label: 'Отмена',
          onTap: onCancel,
        ),
        action: AppBarButton(
          label: 'Готово',
          onTap: onDone,
        ),
      );
    } else {
      // AppBar для режима просмотра
      return CustomAppBar(
        titleText: title,
        leading: AppBarButton(
          label: 'Настройки',
          onTap: onSettings,
        ),
        action: AppBarButton(
          label: 'Изменить',
          onTap: onEdit,
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
