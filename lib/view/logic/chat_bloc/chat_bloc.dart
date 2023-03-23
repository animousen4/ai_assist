import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/view/logic/impl/addable.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:rxdart/rxdart.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatReady> {
  final ChatGPT? chatGPT;
  final bool isTemplate;
  final logger = Logger();
  late final List<ExtendedMessage> extendedMessages;
  ChatBloc({this.isTemplate = false, this.chatGPT})
      : super(ChatReady(
            messages: [], chatStatus: ChatStatus.ok, isTemplate: isTemplate)) {
    extendedMessages = [];
    on<AddMessageEvent>((event, emit) async {
      extendedMessages.add(ExtendedMessage(
          date: DateTime.now(),
          content: event.messages.first.content,
          role: event.messages.first.role));
      emit(ChatReady(
          messages: extendedMessages,
          chatStatus: ChatStatus.processing,
          isTemplate: isTemplate));

      await chatGPT?.sendUnsavedMessages(extendedMessages);
      emit(ChatReady(
          messages: extendedMessages,
          chatStatus: ChatStatus.ok,
          isTemplate: isTemplate));
    });

    on<_ReceiveError>((event, emit) {
      emit(ChatReady(
          messages: extendedMessages,
          chatStatus: ChatStatus.error,
          isTemplate: isTemplate));
    });
    on<_RecieveMessage>((event, emit) {});
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(_ReceiveError(error));
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    //logger.i("CLOSE");
    return super.close();
  }
}
