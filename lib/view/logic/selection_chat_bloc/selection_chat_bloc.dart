import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'selection_chat_event.dart';
part 'selection_chat_state.dart';

class SelectionChatBloc extends Bloc<SelectionChatEvent, SelectionChatState> {
  final MessageDatabase messageDatabase;
  final Logger logger = Logger();
  SelectionChatBloc({required this.messageDatabase})
      : super(SelectionChatState(selectedMessagesId: [], isModificationMode: false)) {
    on<SelectMessage>((event, emit) {
      if (state.selectedMessagesId.contains(event.chatId)) {
        emit(state.copyWith(
            selectedMessagesId: state.selectedMessagesId
              ..remove(event.chatId)));
      } else {
        emit(state.copyWith(
            selectedMessagesId: state.selectedMessagesId..add(event.chatId)));
      }
    });

    on<DeleteSelectedMessages>((event, emit) async {
      logger.d("Deleting message");
      await (messageDatabase.update(messageDatabase.messages)
            ..where((tbl) => tbl.id.isIn(state.selectedMessagesId)))
          .write(MessagesCompanion(messageStatus: Value(1)));
      emit(state.copyWith(selectedMessagesId: []));
    });

    on<ModifySelectedMessage>((event, emit) async {
      await (messageDatabase.update(messageDatabase.messages)
            ..where((tbl) => tbl.chatId.equals(state.selectedMessagesId.first)))
          .write(MessagesCompanion(content: Value(event.newText)));
    });
  }
}
