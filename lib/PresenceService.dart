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
    _instance!._setOnline();
  }

  void _setOnline() {
    ref.set({"online": true});
    ref.onDisconnect().set({
      "online": false,
      "lastSeen": ServerValue.timestamp,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      _setOnline();
  }
}
