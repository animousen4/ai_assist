part of 'selection_bloc.dart';

class SelectionState {
  final List<int> selectedChatIds;
  bool get isSelectionMode => selectedChatIds.isNotEmpty;
  bool get isSingleSelection => selectedChatIds.length == 1;
  //bool get canCopyToOtherSection
  SelectionState({required this.selectedChatIds});

  SelectionState copyWith({List<int>? selectedChatIds}) =>
      SelectionState(selectedChatIds: selectedChatIds ?? this.selectedChatIds);
}
