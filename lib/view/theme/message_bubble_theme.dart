import 'package:flutter/material.dart';

class MessageBubbleTheme extends ThemeExtension<MessageBubbleTheme> {
  final Color? messageColor;
  final Color? textColor;
  final Color? topperCodeColor;
  final Color? textHighlightColor;

  MessageBubbleTheme(
      {this.messageColor,
      this.textColor,
      this.topperCodeColor,
      this.textHighlightColor});
  @override
  ThemeExtension<MessageBubbleTheme> copyWith(
      {Color? messageColor,
      Color? textColor,
      Color? topperCodeColor,
      Color? textHighlightColor}) {
    return MessageBubbleTheme(
        messageColor: messageColor ?? this.messageColor,
        textColor: textColor ?? this.textColor,
        topperCodeColor: topperCodeColor ?? this.topperCodeColor,
        textHighlightColor: textHighlightColor ?? this.textHighlightColor);
  }

  @override
  ThemeExtension<MessageBubbleTheme> lerp(MessageBubbleTheme? other, double t) {
    if (this == other) {
      return this;
    }
    return MessageBubbleTheme(
        messageColor: Color.lerp(messageColor, other?.messageColor, t),
        textColor: Color.lerp(textColor, other?.textColor, t),
        topperCodeColor: Color.lerp(topperCodeColor, other?.topperCodeColor, t),
        textHighlightColor:
            Color.lerp(textHighlightColor, other?.textHighlightColor, t));
  }
}
