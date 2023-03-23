import 'package:gpt_api/gpt_api.dart';

class ChatManager {
  final ChatGptService chatGptService;

  ChatManager(this.chatGptService);
  ChatGPT get newOnlineChat => ChatGPT(chatGptService: chatGptService);
  ChatGPT get newOfflineChat => ChatGPT(chatGptService: null);
}
