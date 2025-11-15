import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/components/DividerLine.dart';
import 'package:last_telemedicine/pages/News_feed.dart';
import 'package:last_telemedicine/pages/user_pages/applications_user.dart';
import 'package:last_telemedicine/pages/user_pages/profile_settings_user.dart';
import 'package:last_telemedicine/pages/user_pages/subpages/Change_city.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/Placeholder.dart';
import '../pages/doctor_pages/applications_doctor.dart';
import '../pages/doctor_pages/main_doctor.dart';
import '../pages/doctor_pages/profile_doctor.dart';
import '../pages/user_pages/profile_user.dart';
import '../pages/legacy/profile_user_legacy.dart';
import 'Notification/ChatListenerService.dart';
import 'Notification/Listener_call_listener_service.dart';

class BottomNavigator extends StatefulWidget {
  final int initialIndex;
  final String usertype;

  const BottomNavigator({
    Key? key,
    this.initialIndex = 0, // ← значение по умолчанию
    required this.usertype,
  }) : super(key: key);


  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}


class _BottomNavigatorState extends State<BottomNavigator> {
  late int _currentIndex;
  late final String _usertype = widget.usertype;
  final ListenerCallListenerService _callListener = ListenerCallListenerService();
  final ChatListenerService _chatListener = ChatListenerService();

  // int _currentIndex = 2; // <- ВОТ СЮДА ПЕРЕДАВАТЬ КАКУЮ СТРАНИЦУ ОТКРЫТЬ

  // NewsFeedPage(), ApplicationsPage(), ProfilePageUser()
  // final List<Widget> _pages = [MainDoctor(), ApplicationsPageDoctor(), ProfilePageDoctor()];



  late List<Widget> _pages;


  void initState() {
    super.initState();

    if (widget.usertype == 'doctor') {
      _pages = [
        MainDoctor(),
        ApplicationsPageDoctor(),
        ProfilePageDoctor(),
      ];
    } else {
      _pages = [
        NewsFeedPage(), ApplicationsPage(), ProfilePageUser()
      ];
    }

    _currentIndex = widget.initialIndex;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _callListener.startListening(currentUser.uid);
      _chatListener.startListening(currentUser.uid);
    }

  }

  @override
  void dispose() {
    // Останавливаем прослушивание ОДИН РАЗ при уничтожении виджета
    _callListener.stopListening();
    _chatListener.stopListening();
    super.dispose();
  }

    void _navigateBottomBar(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _pages[_currentIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DividerLine(), // ← полоска сверху
            BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: _navigateBottomBar,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFFFF4361),
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/icons/feed_icon.svg',
                    width: 25.5,
                    height: 25.5,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/icons/feed_icon.svg',
                    width: 25.5,
                    height: 25.5,
                    color: Color(0xFFFF4361), // ← активный цвет
                  ),
                  label: 'Лента',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/icons/heart_icon.svg',
                    width: 25.5,
                    height: 25.5,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/icons/heart_icon.svg',
                    width: 25.5,
                    height: 25.5,
                    color: Color(0xFFFF4361),
                  ),
                  label: 'Заявки',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/icons/userProfile.svg',
                    width: 25.5,
                    height: 25.5,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/images/icons/userProfileРозовый.svg',
                    width: 25.5,
                    height: 25.5,
                  ),
                  label: 'Профиль',
                ),
              ],
            ),
            const SizedBox(height: 30), // ← отступ снизу
          ],
        ),
      );
    }
  }



