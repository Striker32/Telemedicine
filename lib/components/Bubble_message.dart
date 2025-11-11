import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_telemedicine/themes/AppColors.dart';

Widget buildMessageItem(DocumentSnapshot doc, senderID, context) {
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
        color: isSender ? AppColors.additionalAccent : const Color(0xFFFFFFFF),
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
