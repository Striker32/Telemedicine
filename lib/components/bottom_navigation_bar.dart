import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;



  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF497C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/icons/feed_icon.png')),
          label: 'Лента',
          activeIcon: ImageIcon(
              AssetImage('assets/images/icons/feed_icon.png'),
              color: const Color(0xFFFF497C),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Заявки',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}
