import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/chat/chat_service.dart';
import 'package:last_telemedicine/components/Bubble_message.dart';
import 'package:last_telemedicine/components/Notification.dart';
import '../../themes/AppColors.dart';
import '../components/Chat_header.dart';
import '../components/DividerLine.dart';
import 'package:firebase_database/firebase_database.dart';

class ChathistoryScreen extends StatefulWidget {
  final String requestID;
  final String recieverID;
  final String senderID;
  final Blob? avatar;

  const ChathistoryScreen({
    Key? key,
    required this.requestID,
    required this.recieverID,
    required this.senderID,
    this.avatar = null,
  }) : super(key: key);

  @override
  State<ChathistoryScreen> createState() => _ChathistoryScreenState();
}

class _ChathistoryScreenState extends State<ChathistoryScreen> {
  final TextEditingController _controller = TextEditingController();
  final _chatService = ChatService();
  bool online = false;
  Timestamp? lastSeenAgo;

  late DatabaseReference _presenceRef;
  late Stream<DatabaseEvent> _presenceStream;

  bool _canSend = false;
  String firstname = '';
  String lastname = '';

  Future<void> _loadRecieverData() async {
    final chatService = ChatService();
    final recieverData = await chatService.fetchRecieverData(widget.recieverID);
    if (recieverData != null) {
      setState(() {
        firstname = recieverData['name'] ?? '';
        lastname = recieverData['surname'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _presenceRef = FirebaseDatabase.instance.ref(
      'presence/${widget.recieverID}',
    );
    _presenceStream =
        _presenceRef.onValue; // кэшируем один раз для этого экрана

    _loadRecieverData();

    _controller.addListener(() {
      final cleanedText = _controller.text
          .split('\n')
          .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
          .where((line) => line.isNotEmpty)
          .join('\n');
      final hasText = cleanedText.isNotEmpty;

      if (hasText != _canSend) {
        setState(() => _canSend = hasText);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChathistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recieverID != widget.recieverID) {
      _presenceRef = FirebaseDatabase.instance.ref(
        'presence/${widget.recieverID}',
      );
      _presenceStream = _presenceRef.onValue;
      setState(() {}); // перерисовать header с новым стримом
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: StreamBuilder<DatabaseEvent>(
          stream: _presenceStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return ChatHeader(
                firstName: firstname,
                lastName: lastname,
                online: false,
                lastSeenAgo: Timestamp(0, 0),
                avatarUrl: widget.avatar,
                onBack: () => Navigator.maybePop(context),
              );
            }

            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final isOnline = data['online'] as bool;
            final lastSeen = data['lastSeen'] != null
                ? Timestamp.fromMillisecondsSinceEpoch(data['lastSeen'])
                : null;

            return ChatHeader(
              firstName: firstname,
              lastName: lastname,
              online: isOnline,
              lastSeenAgo: lastSeen,
              avatarUrl: widget.avatar,
              onBack: () => Navigator.maybePop(context),
            );
          },
        ),
      ),
      body: Column(children: [Expanded(child: _buildMessageList())]),
      backgroundColor: AppColors.background2,

      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          color: const Color(0xFFFAFBFD),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DividerLine(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 6.0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 12.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Center(
                    child: Text(
                      'Вы не можете отправлять или получать сообщения. Это история Вашего чата.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.addLightText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.requestID),
      builder: (context, snap) {
        // catch errors
        if (snap.hasError) {
          showCustomNotification(
            context,
            'При загрузке сообщений произошла ошибка. Попробуйте ещё раз',
          );
          return const SizedBox.shrink();
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'В диалоге не было сообщений.\nКажется Вы ничего не писали или\nпроизошла какая-то ошибка..',
              style: TextStyle(color: AppColors.primaryText),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView(
          reverse: true,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          children: snap.data!.docs
              .map((doc) => buildMessageItem(doc, widget.senderID, context))
              .toList()
              .reversed
              .toList(), // ← инвертируем порядок
        );
      },
    );
  }
}
