import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputPro extends StatelessWidget {
  final TextEditingController chatTextFieldController = TextEditingController();
  late final _focusNode = FocusNode(
    onKey: _handleKeyPress,
  );

  final Function(String text) onSubmit;
  final Function(String text)? onTextChanged;
  final InputDecoration? inputDecoration;
  TextInputPro({super.key, required this.onSubmit, this.onTextChanged, this.inputDecoration});

  KeyEventResult _handleKeyPress(FocusNode focusNode, RawKeyEvent event) {
    // handles submit on enter
    if (event.isKeyPressed(LogicalKeyboardKey.enter) && !event.isShiftPressed) {
      _sendMessage();
      // handled means that the event will not propagate
      return KeyEventResult.handled;
    }
    // ignore every other keyboard event including SHIFT+ENTER
    return KeyEventResult.ignored;
  }

  void _sendMessage() {
    if (chatTextFieldController.text.trim().isNotEmpty) {
      onSubmit(chatTextFieldController.text);
      Future.delayed(Duration.zero, () {
        _focusNode.requestFocus();
        chatTextFieldController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      onChanged: onTextChanged,
      autofocus: true,
      focusNode: _focusNode,
      decoration: inputDecoration,
      controller: chatTextFieldController,
    );
  }
}
