// // lib/services/chat_service.dart
// import 'dart:async';
// import "package:uuid/uuid.dart";
//
// import 'ChatMessage.dart';
//
// typedef MessageListener = void Function(List<ChatMessage> messages);
//
// class ChatService {
//   // В памяти: основной источник правды для UI (можно заменить на Provider/riverpod)
//   final List<ChatMessage> _messages = [];
//
//   // Поток для подписки UI
//   final StreamController<List<ChatMessage>> _controller =
//   StreamController<List<ChatMessage>>.broadcast();
//
//   // Идентификатор текущего пользователя (в реальном приложении берите из auth)
//   final String myId;
//
//   // Простая генерация id для локальных/тестовых сообщений
//   final Uuid _uuid = const Uuid();
//
//   ChatService({required this.myId});
//
//   Stream<List<ChatMessage>> get messagesStream => _controller.stream;
//
//   List<ChatMessage> get snapshot => List.unmodifiable(_messages);
//
//   void dispose() {
//     _controller.close();
//   }
//
//   // 1) Создать и показать локальное сообщение (пока отправка идёт асинхронно)
//   ChatMessage createLocalMessage({required String text, required String recipientId}) {
//     final localId = 'local_${_uuid.v4()}';
//     final msg = ChatMessage(
//       id: localId,
//       text: text,
//       senderId: myId,
//       recipientId: recipientId,
//       createdAt: DateTime.now().toUtc(),
//       isRead: false,
//     );
//     _insertMessage(msg);
//     // Здесь можно сразу запустить sendMessage(msg)
//     return msg;
//   }
//
//   // 2) Вставка сообщения в локальный список (в начало списка — для reverse: true UI)
//   void _insertMessage(ChatMessage msg) {
//     _messages.insert(0, msg);
//     _emit();
//   }
//
//   // 3) Эмиттить состояние
//   void _emit() {
//     _controller.add(List.unmodifiable(_messages));
//   }
//
//   // 4) Публичный метод отправки: создано локально, затем отправляется на сервер
//   Future<void> sendMessage(ChatMessage localMsg) async {
//     try {
//       // Пример: call your API / Firebase here
//       // final serverObj = await api.sendMessage(localMsg.toJson());
//       // final serverId = serverObj['id'];
//       // final serverCreatedAt = DateTime.parse(serverObj['createdAt']);
//
//       // Для демонстрации эмулируем задержку и ответ:
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       // Эмулируем серверный id и createdAt
//       final serverId = _uuid.v4();
//       final serverCreatedAt = DateTime.now().toUtc();
//
//       // Заменяем локальное сообщение на серверное (по локальному id)
//       final i = _messages.indexWhere((m) => m.id == localMsg.id);
//       if (i != -1) {
//         _messages[i] = localMsg.copyWith(id: serverId, createdAt: serverCreatedAt);
//         _emit();
//       }
//     } catch (e) {
//       // При ошибке можно пометить сообщение (сюда можно добавить поле status)
//       // Здесь простая стратегия: оставляем локальное и не меняем.
//       rethrow;
//     }
//   }
//
//   // 5) Получение истории (страницы)
//   Future<List<ChatMessage>> fetchHistory({
//     required String withUserId,
//     String? beforeId, // для пагинации
//     int limit = 50,
//   }) async {
//     // В реальном приложении делаете запрос к серверу/Firebase
//     // Здесь заглушка: возвращаем часть _messages или пустой список
//     await Future.delayed(const Duration(milliseconds: 200));
//     // Если beforeId == null — вернуть первые limit новых у сервиса (reverse=false предположим)
//     final result = _messages.where((m) =>
//     (m.senderId == withUserId && m.recipientId == myId) ||
//         (m.senderId == myId && m.recipientId == withUserId)).toList();
//     return result; // сортировка/фильтрация по createdAt — по необходимости
//   }
//
//   // 6) Отметить как прочитанное: обновление локально и (опционально) серверный вызов
//   Future<void> markAsRead(String messageId) async {
//     final i = _messages.indexWhere((m) => m.id == messageId);
//     if (i != -1 && !_messages[i].isRead) {
//       _messages[i] = _messages[i].copyWith(isRead: true);
//       _emit();
//       // call server to mark read
//       // await api.markRead(messageId);
//     }
//   }
//
//   // 7) Вставка сообщений, пришедших с сервера (например, websocket/update listener)
//   void upsertServerMessages(List<ChatMessage> serverMessages) {
//     for (final serverMsg in serverMessages) {
//       final i = _messages.indexWhere((m) => m.id == serverMsg.id || (m.id.startsWith('local_') && m.createdAt == serverMsg.createdAt));
//       if (i != -1) {
//         _messages[i] = serverMsg;
//       } else {
//         _messages.insert(0, serverMsg);
//       }
//     }
//     _emit();
//   }
//
// // 8) Удаление / retry / replace — дополнительные методы по необходимости
// }
