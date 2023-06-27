import 'dart:ffi';

import 'package:ai_assist/model/syntax/syntax_description.dart';
import 'package:ai_assist/view/theme/message_bubble_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.text,
    this.codeViewThemeIndex = 0,
    this.isMine = true,
    this.format = true,
  });
  final bool format;
  final bool isMine;
  final int codeViewThemeIndex;
  final String text;

  @override
  Widget build(BuildContext context) {
    final widgetTheme = Theme.of(context).extension<MessageBubbleTheme>()!;
    return Container(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width * (isMine ? 0.6 : 0.9)),
          //alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: buildWidget(context, widgetTheme),
          ),
          decoration: BoxDecoration(
              color: widgetTheme.messageColor,
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildWidget(BuildContext context, MessageBubbleTheme widgetTheme) {
    final syntaxTheme =
        SyntaxDescription.getAllSyntaxes[codeViewThemeIndex].theme;
    List<Widget> widgets = [];
    List<String> lines = text.split('\n');
    String curBlock = "";
    String line;
    for (int i = 0; i < lines.length; i++) {
      line = lines[i];

      if (line.contains("```") && format) {
        String codeSpec = "code";
        if (line.length > 3) {
          codeSpec += "(${line.substring(3)})";
        }

        // form block
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SelectableText.rich(TextSpan(
              children: getTextSpanFromLine(curBlock, widgetTheme),
              style: GoogleFonts.roboto(color: widgetTheme.textColor))),
        ));
        curBlock = "";

        // create code block
        i++;
        line = lines[i];
        while (!line.contains("```") && i < lines.length) {
          curBlock += "$line\n";
          i++;
          line = lines[i];
        }

        if (curBlock.endsWith("\n")) {
          curBlock = curBlock.substring(0, curBlock.length - 1);
        }

        // close line block and push widget
        widgets.add(Padding(
          padding: const EdgeInsets.all(2.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.center,
              child: (String code) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: widgetTheme.topperCodeColor
                          //Color(0xFF93C763) //Colors.grey[700],
                          ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(codeSpec,
                                style: GoogleFonts.roboto(
                                    color: widgetTheme.textColor)),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: code));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Copied!"),
                                    duration: Duration(milliseconds: 300),
                                  ));
                                },
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.copy),
                                iconSize: 16,
                                splashRadius: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      alignment: Alignment.topLeft,
                      color: syntaxTheme.backgroundColor,
                      child: SingleChildScrollView(
                        child: SyntaxView(
                          fontSize: 11,
                          code: curBlock,
                          withZoom: false,
                          syntax: Syntax.C,
                          syntaxTheme: syntaxTheme,
                        ),
                      ),
                    ),
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                          color: syntaxTheme.backgroundColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                    )
                  ],
                );
              }.call(curBlock),
            ),
          ),
        ));

        curBlock = "";
      } else {
        curBlock += "$line\n";
      }
    }

    if (curBlock.isNotEmpty) {
      widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SelectableText.rich(TextSpan(
              style: GoogleFonts.roboto(color: widgetTheme.textColor),
              children: getTextSpanFromLine(
                  curBlock.endsWith("\n")
                      ? curBlock.substring(0, curBlock.length - 1)
                      : curBlock,
                  widgetTheme)))));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<TextSpan> getTextSpanFromLine(
      String line, MessageBubbleTheme widgetTheme) {
    List<TextSpan> list = [];
    String curText = "";
    for (int i = 0; i < line.length; i++) {
      if (line[i] == "`") {
        list.add(TextSpan(text: curText));
        curText = "";
        i++;
        while (i < line.length && line[i] != '`') {
          curText += line[i];
          i++;
        }

        list.add(TextSpan(
            text: curText,
            style:
                GoogleFonts.robotoMono(color: widgetTheme.textHighlightColor)));

        curText = "";
      } else {
        curText += line[i];
      }
    }

    if (curText.isNotEmpty) {
      list.add(TextSpan(text: curText));
    }
    return list;
  }
}
