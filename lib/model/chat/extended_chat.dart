import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:gpt_api/gpt_api.dart';

class ExtendedChat {
  final String name;
  final int chatId;
  final List<Message> messages;

  factory ExtendedChat.fromChat(Chat chat, List<Message> messages) =>
      ExtendedChat(
          chatId: chat.chatId, name: chat.chatName, messages: messages);
  ExtendedChat(
      {required this.chatId, required this.name, required this.messages});
}
