part of 'selection_chat_bloc.dart';

class SelectionChatState {
  final List<int> selectedMessagesId;
  final bool isModificationMode;
  bool get isSelectionMode => selectedMessagesId.isNotEmpty;
  bool get isSingleSelection => selectedMessagesId.length == 1;
  SelectionChatState({required this.selectedMessagesId, required this.isModificationMode});

  SelectionChatState copyWith({List<int>? selectedMessagesId, bool? isModificationMode}) =>
      SelectionChatState(
          selectedMessagesId: selectedMessagesId ?? this.selectedMessagesId,
          isModificationMode: isModificationMode ?? this.isModificationMode);
}
