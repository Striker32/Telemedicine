import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../themes/AppColors.dart';
import '../components/Chat_header.dart';
import '../components/DividerLine.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  final String requestID;
  final String recieverID;

  const ChatScreen({
    Key? key,
    required this.requestID,
    required this.recieverID,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;
  String firstname = '';
  String lastname = '';
  bool online = false;
  Timestamp lastSeenAgo = Timestamp(0, 0);
  String avatarUrl = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
      body: const Center(
        child: Text(
          'В диалоге ещё нет сообщений.\nНачните общение прямо сейчас!',
          style: TextStyle(color: AppColors.primaryText),
          textAlign: TextAlign.center,
        ),
      ),
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
                      onTap: _canSend
                          ? () {
                              debugPrint('Написать хотел? Хаха, а вот хуй!');
                              // TODO: отправка сообщения
                            }
                          : null,
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
}
