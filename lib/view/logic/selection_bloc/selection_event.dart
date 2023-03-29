part of 'selection_bloc.dart';

@immutable
abstract class SelectionEvent {}

class SelectChat extends SelectionEvent {
  final int chatId;

  SelectChat(this.chatId);
}

abstract class DoAction extends SelectionEvent {}

class DeleteChats extends DoAction {}

class EmptyChats extends DoAction {}

class MakeCopy extends DoAction {
  final int? targetChatType;

  MakeCopy({this.targetChatType});
}

class MakeCopyToTemplates extends DoAction {}

class Rename extends DoAction {
  final String newName;

  Rename(this.newName);
}
