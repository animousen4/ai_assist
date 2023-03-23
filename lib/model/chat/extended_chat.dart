import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:gpt_api/gpt_api.dart';

class ExtendedChat {
  final String name;
  final List<ExtendedMessage> messages;

  ExtendedChat({required this.name, required this.messages});
}
