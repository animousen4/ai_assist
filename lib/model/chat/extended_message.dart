import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:gpt_api/gpt_api.dart';

class ExtendedMessage extends MessageAdapter {
  final DateTime date;

  ExtendedMessage(
      {required this.date, required super.content, required super.role});

  factory ExtendedMessage.fromMessage(Message message) =>
      ExtendedMessage(date: message.data, content: message.content, role: ChatGptRole.valueOf(message.role));
}
