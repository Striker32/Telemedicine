import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import '../themes/AppColors.dart';
import 'Appbar/AppBarButton.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final bool online;
  final Duration? lastSeenAgo;
  final String? avatarUrl;
  final VoidCallback? onBack;

  const ChatHeader({
    Key? key,
    this.firstName = '',
    this.lastName = '',
    this.online = false,
    this.lastSeenAgo,
    this.avatarUrl,
    this.onBack,
  }) : super(key: key);

  String _statusText() {
    if (online) return 'онлайн';
    if (lastSeenAgo == null) return 'был(-а) давно';
    final m = lastSeenAgo!.inMinutes;
    if (m < 1) return 'только что';
    return 'был(-а) в сети $m минут назад';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final title = '${firstName.trim()} ${lastName.trim()}'.trim();
    final status = _statusText();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: AppBarButton(
          label: 'Назад',
          onTap: onBack ?? () => Navigator.maybePop(context),
        ),
      ),
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.isEmpty ? 'Пользователь' : title,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (status.isNotEmpty)
            Text(
              status,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.addLightText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: SizedBox(
            width: 38,
            height: 38,
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(4), // или 0 если нужен прямоугольный
              child: Image.network(
                avatarUrl!,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            )
                : SvgPicture.asset(
              'assets/images/icons/userProfile.svg',
              width: 38,
              height: 38,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: DividerLine(),
      ),
    );
  }
}
