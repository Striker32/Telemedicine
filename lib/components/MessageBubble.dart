// // lib/widgets/message_bubble.dart
// import 'package:flutter/material.dart';
// import '../../themes/AppColors.dart';
// import 'ChatMessage.dart';

// class MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final String myId;
//   final VoidCallback? onTap;
//   final Widget? leadingAvatar; // опционально, рисуется для чужих сообщений
//   final bool showTime; // показывать время снизу

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.myId,
//     this.onTap,
//     this.leadingAvatar,
//     this.showTime = true,
//   }) : super(key: key);

//   bool get _isMine => message.senderID == myId;

//   @override
//   Widget build(BuildContext context) {
//     final maxWidth = MediaQuery.of(context).size.width * 0.72;

//     final bubble = ConstrainedBox(
//       constraints: BoxConstraints(maxWidth: maxWidth),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: _isMine ? AppColors.mainColor : Colors.white,
//             borderRadius: _bubbleRadius(),
//             border: Border.all(color: const Color(0xFFD1D1D6), width: 1),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 message.text,
//                 style: TextStyle(
//                   color: _isMine ? Colors.white : Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               if (showTime)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         _formatTime(message.createdAt, context),
//                         style: TextStyle(
//                           color: (_isMine ? Colors.white70 : Colors.black54),
//                           fontSize: 12,
//                         ),
//                       ),
//                       if (_isMine) const SizedBox(width: 6),
//                       if (_isMine)
//                         Icon(
//                           message.isRead ? Icons.done_all : Icons.check,
//                           size: 14,
//                           color: message.isRead ? Colors.white70 : Colors.white70,
//                         ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (_isMine) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             bubble,
//           ],
//         ),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (leadingAvatar != null) ...[
//               leadingAvatar!,
//               const SizedBox(width: 8),
//             ],
//             bubble,
//             const Spacer(),
//           ],
//         ),
//       );
//     }
//   }

//   BorderRadius _bubbleRadius() {
//     if (_isMine) {
//       return const BorderRadius.only(
//         topLeft: Radius.circular(16),
//         topRight: Radius.circular(16),
//         bottomLeft: Radius.circular(16),
//         bottomRight: Radius.circular(4),
//       );
//     } else {
//       return const BorderRadius.only(
//         topLeft: Radius.circular(16),
//         topRight: Radius.circular(16),
//         bottomLeft: Radius.circular(4),
//         bottomRight: Radius.circular(16),
//       );
//     }
//   }

//   String _formatTime(DateTime dt, BuildContext context) {
//     final local = dt.toLocal();
//     final hours = local.hour.toString().padLeft(2, '0');
//     final minutes = local.minute.toString().padLeft(2, '0');
//     return '$hours:$minutes';
//   }
// }
