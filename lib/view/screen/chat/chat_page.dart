import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:ai_assist/view/logic/chat_manager/chat_manager.dart';
import 'package:ai_assist/view/widget/chat_header_sliver.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/chat_bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, @PathParam('chatId') required this.chatId});
  final int chatId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textEditingController;
  late final ScrollController _scrollController;
  ChatGptRole chatGptRole = ChatGptRole.user;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
          chatId: widget.chatId,
          messageDatabase: context.read<MessageDatabase>(),
          chatGptService: context.read<ChatManager>().chatGptService),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return state.extendedChat == null
                    ? SizedBox()
                    : Text("${state.extendedChat!.name} [${state.msgStatus}]");
              },
            ),
          ),
          body: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) async {
                if (state.error != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                          SnackBar(content: Text("Error: ${state.error}")))
                      .closed
                      .then((value) =>
                          context.read<ChatBloc>().add(ClearError()));
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.extendedChat == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.extendedChat!.messages.isEmpty) {
                    if (state.isTemplate == null) return SizedBox();
                    return Center(
                      child: state.isTemplate!
                          ? Text(
                              "Write a message with role to create template!")
                          : Text(
                              "No messages! Write anything to start up a dialog!"),
                    );
                  } else {
                    final msgs = state.extendedChat!.messages.reversed.toList();
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: index == 0 ? 70 : 0),
                        child: BubbleNormal(
                          text: msgs[index].content,
                          isSender: msgs[index].role == ChatGptRole.user,
                        ),
                      ),
                      itemCount: state.extendedChat!.messages.length,
                    );
                  }
                },
              ),
            ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state.isTemplate == null) {
                      return SizedBox();
                    }
                    return state.isTemplate!
                        ? SizedBox(
                            child: DropdownButtonFormField<ChatGptRole>(
                                borderRadius: BorderRadius.circular(10.0),
                                value: chatGptRole,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("User"),
                                    value: ChatGptRole.user,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Assistant"),
                                    value: ChatGptRole.assistant,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("System"),
                                    value: ChatGptRole.system,
                                  ),
                                ],
                                onChanged: (a) {
                                  chatGptRole = a!;
                                }),
                            width: 120,
                          )
                        : SizedBox();
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 100),
                    child: TextFormField(
                      maxLines: null,
                      controller: textEditingController,
                      onFieldSubmitted: (v) => _submitMessage(context),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              _submitMessage(context);
                            },
                            icon: Icon(Icons.send)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _submitMessage(BuildContext context) {
    //logger.d("Submitted: $messageText");
    context.read<ChatBloc>().add(AddMessageEvent([
          MessageAdapter(content: textEditingController.text, role: chatGptRole)
        ]));
    setState(() {
      textEditingController.text = "";
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    textEditingController = TextEditingController(text: "");
    super.initState();
  }
}
