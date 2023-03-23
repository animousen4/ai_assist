import 'dart:math';

import 'package:ai_assist/model/chat/extended_chat.dart';
import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:ai_assist/view/logic/impl/addable.dart';
import 'package:bloc/bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:meta/meta.dart';

part 'talk_manager_event.dart';
part 'talk_manager_state.dart';

class TalkManagerBloc extends Bloc<TalkManagerEvent, TalkManagerState> {
  final bool isTempl;
  final AbstractMessageDatabase messageDatabase;
  TalkManagerBloc({required this.isTempl, required this.messageDatabase})
      : super(TalkManagerState([])) {
    messageDatabase.select(messageDatabase.messages).watch().listen((event) {
      //add(_UpdateChats(event.map<ExtendedChat>(
      //    (e) => ExtendedChat(name: "LO", messages: messages)).toList()));
    });
    on<TalkManagerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<_UpdateChats>((event, emit) {
      emit(TalkManagerState(event.chatList));
    });
    on<LoadChats>((event, emit) {
      // EMIT SORTED CHATS
      //final List<ExtendedChat> sortedChats = [];

      // add stream and sub, listen upd
      //sortedChats.add(ExtendedChat(name: "Chattt", messages: []));
      emit(TalkManagerState([]));
    });
  }
}
