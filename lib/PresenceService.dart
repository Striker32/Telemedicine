import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class PresenceService with WidgetsBindingObserver {
  final String uid;
  final DatabaseReference ref;

  PresenceService._(this.uid, this.ref);

  static PresenceService? _instance;

  static void init(String uid, {required bool online}) {
    final ref = FirebaseDatabase.instance.ref("presence/$uid");
    _instance = PresenceService._(uid, ref);
    WidgetsBinding.instance.addObserver(_instance!);

    if (online) {
      _instance!._setOnline();
      ref.onDisconnect().set({
        "online": false,
        "lastSeen": ServerValue.timestamp,
      });
    } else {
      _instance!._setOffline();
    }
  }

  void _setOffline() {
    ref.set({"online": false, "lastSeen": ServerValue.timestamp});
  }

  void _setOnline() {
    ref.set({"online": true});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _instance!._setOnline();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _instance!._setOffline();
    }
  }
}
