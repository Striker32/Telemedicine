import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/chat/chat_service.dart';
import 'package:last_telemedicine/components/Loading.dart';
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

  void sendMessage() async {
    final message = _controller.text;

    // Очистка поля ввода
    _controller.clear();

    await _chatService.sendMessage(
      widget.recieverID,
      widget.senderID,
      widget.requestID,
      message,
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
      final hasText = _controller.text.trim().isNotEmpty;
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
                      onTap: sendMessage,
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
          children: snap.data!.docs
              .map((doc) => _buildMessageItem(doc, widget.senderID))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, senderID) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isSender = data['senderID'] == senderID;

    final screenWidth = MediaQuery.of(context).size.width;
    final maxBubbleWidth = screenWidth - 125;

    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isSender ? 20 : 5),
      bottomRight: Radius.circular(isSender ? 5 : 20),
    );

    final timestamp = data['createdAt'] as Timestamp?;
    final timeString = timestamp != null
        ? "${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
        : "--:--";

    return Container(
      alignment: alignment,
      margin: isSender
          ? const EdgeInsets.only(bottom: 5, right: 12)
          : const EdgeInsets.only(bottom: 5, left: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        decoration: BoxDecoration(
          color: isSender
              ? AppColors.additionalAccent
              : const Color(0xFFFFFFFF),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                data["message"] ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              timeString,
              style: TextStyle(
                fontSize: 12,
                color: isSender ? AppColors.mainColor : AppColors.addLightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
