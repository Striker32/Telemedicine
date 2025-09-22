import 'package:flutter/material.dart';
import 'package:last_telemedicine/auth/auth_service.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Homepage Placeholder"),
      actions: [
        IconButton(onPressed: logout, icon: Icon(Icons.logout)),
      ],),
    );
  }
}
