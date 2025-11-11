import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/chat/chat_service.dart';
import 'package:last_telemedicine/components/Bubble_message.dart';
import 'package:last_telemedicine/components/Notification.dart';
import '../../themes/AppColors.dart';
import '../components/Chat_header.dart';
import '../components/DividerLine.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  final String requestID;
  final String recieverID;
  final String senderID;

  const ChatScreen({
    Key? key,
    required this.requestID,
    required this.recieverID,
    required this.senderID,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final _chatService = ChatService();

  final AudioPlayer _audioPlayer = AudioPlayer();

  void sendMessage() async {
    final cleanedMessage = _controller.text
        .split('\n')
        .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
        .where((line) => line.isNotEmpty)
        .join('\n');
    // Очистка поля ввода
    _controller.clear();

    _playSendSound();

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller.clear();
    });

    _chatService.sendMessage(
      widget.recieverID,
      widget.senderID,
      widget.requestID,
      cleanedMessage,
    );
  }

  bool _canSend = false;
  String firstname = '';
  String lastname = '';
  bool online = false;
  Timestamp lastSeenAgo = Timestamp(0, 0);
  String avatarUrl = '';

  Future<void> _loadRecieverData() async {
    final chatService = ChatService();
    final recieverData = await chatService.fetchRecieverData(widget.recieverID);
    if (recieverData != null) {
      setState(() {
        firstname = recieverData['name'] ?? '';
        lastname = recieverData['surname'] ?? '';
        // avatarUrl = recieverData['avatarUrl'] ?? '';
        // lastSeenAgo = recieverData['updatedAt'] ?? Timestamp(0, 0);
        // online = recieverData['online'] ?? false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: ChatHeader(
        firstName: firstname,
        lastName: lastname,
        online: online,
        lastSeenAgo: lastSeenAgo,
        avatarUrl: avatarUrl,
        onBack: () => Navigator.maybePop(context),
      ),
      body:
          // Center(
          //   child: Text(
          //     'В диалоге ещё нет сообщений.\nНачните общение прямо сейчас!',
          //     style: TextStyle(color: AppColors.primaryText),
          //     textAlign: TextAlign.center,
          //   ),
          // ),//
          Column(children: [Expanded(child: _buildMessageList())]),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint('Позвонить хотел? А вот хуй');
                        // TODO: Начало звонка
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 7),
                            SvgPicture.asset(
                              'assets/images/icons/phone.svg',
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFD1D1D6),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              // Минимальная высота для 1 строки и максимальная для ~12 строк
                              minHeight: 28,
                              maxHeight: 28 * 12, // грубая верхняя граница
                            ),
                            child: Scrollbar(
                              child: TextField(
                                controller: _controller,
                                minLines: 1,
                                maxLines: 12,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  hintText: 'Сообщение',
                                  hintStyle: TextStyle(
                                    color: AppColors.addLightText,
                                    fontSize: 17,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        final cleanedText = _controller.text
                            .split('\n')
                            .map(
                              (line) =>
                                  line.trim().replaceAll(RegExp(r'\s+'), ' '),
                            )
                            .where((line) => line.isNotEmpty)
                            .join('\n');

                        final hasText = cleanedText.isNotEmpty;

                        if (hasText) {
                          sendMessage();
                        }
                      },
                      child: Opacity(
                        opacity: _canSend ? 1.0 : 0.1,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/icons/arrow-up.svg',
                            width: 41,
                            height: 41,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(height: 30, color: const Color(0xFFFAFBFD)),
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

        // загрузка
        // if (snap.connectionState == ConnectionState.waiting) {
        //   return Scaffold(
        //     backgroundColor: AppColors.background2,
        //     body: const PulseLoadingWidget(),
        //   );
        // }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'В диалоге ещё нет сообщений.\nНачните общение прямо сейчас!',
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

  Future<void> _playSendSound() async {
    _audioPlayer.play(AssetSource('sounds/send.mp3'));
  }
}
