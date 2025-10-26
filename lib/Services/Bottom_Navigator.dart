import 'package:flutter/material.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';

import '../pages/Placeholder.dart';
import '../pages/user_pages/profile_change_user.dart';
import '../pages/user_pages/profile_user.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 2;

  final List<Widget> _pages = [ChangeCityPage(), ChangePageUser(), ProfileSettingsPageUser()];

  void _navigateBottomBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateBottomBar,
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
            icon: ImageIcon(AssetImage('assets/images/icons/heart_icon.png')),
            label: 'Заявки',
            activeIcon: ImageIcon(
              AssetImage('assets/images/icons/heart_icon.png'),
              color: const Color(0xFFFF497C),
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
