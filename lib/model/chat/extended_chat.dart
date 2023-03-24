import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:gpt_api/gpt_api.dart';

class ExtendedChat {
  final String name;
  final int chatId;
  final List<ExtendedMessage> messages;

  factory ExtendedChat.fromChat(Chat chat, List<Message> messages) =>
      ExtendedChat(
          chatId: chat.chatId, name: chat.chatName, messages: messages.map<ExtendedMessage>((e) => ExtendedMessage(
                            date: e.data,
                            content: e.content,
                            role: ChatGptRole.valueOf(e.role))).toList());
  ExtendedChat(
      {required this.chatId, required this.name, required this.messages});
}
