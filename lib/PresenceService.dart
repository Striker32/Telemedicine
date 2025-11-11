import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class PresenceService with WidgetsBindingObserver {
  final String uid;
  final DatabaseReference ref;

  PresenceService._(this.uid, this.ref);

  static PresenceService? _instance;

  static void init(String uid) {
    final ref = FirebaseDatabase.instance.ref("presence/$uid");
    _instance = PresenceService._(uid, ref);
    WidgetsBinding.instance.addObserver(_instance!);
    _instance!._setOnline(); // при старте сразу онлайн
  }

  void _setOnline() {
    // отмечаем онлайн
    ref.set({"online": true});
    // регистрируем серверное правило на случай обрыва
    ref.onDisconnect().set({
      "online": false,
      "lastSeen": ServerValue.timestamp,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.set({"online": true});
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ref.set({"online": false, "lastSeen": ServerValue.timestamp});
    }
  }
}
