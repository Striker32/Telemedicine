
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String recipientId;
  final DateTime createdAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.recipientId,
    required this.createdAt,
    this.isRead = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    String? senderId,
    String? recipientId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'senderId': senderId,
    'recipientId': recipientId,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatMessage &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              text == other.text &&
              senderId == other.senderId &&
              recipientId == other.recipientId &&
              createdAt == other.createdAt &&
              isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      senderId.hashCode ^
      recipientId.hashCode ^
      createdAt.hashCode ^
      isRead.hashCode;

}

/// Утиль для создания локального (pending) сообщения
ChatMessage createLocalMessage({
  required String text,
  required String myId,
  required String recipientId,
}) {
  final localId = 'local_${DateTime.now().microsecondsSinceEpoch}';
  return ChatMessage(
    id: localId,
    text: text,
    senderId: myId,
    recipientId: recipientId,
    createdAt: DateTime.now(),
    isRead: false,
  );
}