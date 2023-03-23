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
  const ChatPage(
      {super.key, required this.isTemplate, @PathParam('n') required this.n});
  final bool isTemplate;
  final int n;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textEditingController;
  ChatGptRole chatGptRole = ChatGptRole.user;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
          isTemplate: widget.isTemplate,
          chatGPT: widget.isTemplate
              ? context.read<ChatManager>().newOnlineChat
              : context.read<ChatManager>().newOfflineChat),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ChatBloc, ChatReady>(
              builder: (context, state) {
                return Text("${state.isTemplate ? "Template" : "Chat"}");
              },
            ),
          ) as PreferredSizeWidget,
          body: ExtendedNestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [],
            body: BlocListener<ChatBloc, ChatReady>(
              listener: (context, state) {
                if (state.chatStatus == ChatStatus.error) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheet(
                          onClosing: () {},
                          builder: (c) => Text("An error occured!")));
                }
              },
              child: BlocBuilder<ChatBloc, ChatReady>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: state.isTemplate
                          ? Text(
                              "Write a message with role to create template!")
                          : Text(
                              "No messages! Write anything to start up a dialog!"),
                    );
                  } else {
                    final msgs = state.messages.reversed.toList();
                    return ListView.builder(
                      reverse: true,
                      itemBuilder: (context, index) => BubbleNormal(
                        text: msgs[index].content,
                        isSender: msgs[index].role == ChatGptRole.user,
                      ),
                      itemCount: state.messages.length,
                    );
                  }
                },
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BlocBuilder<ChatBloc, ChatReady>(
                  builder: (context, state) {
                    return state.isTemplate
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
    textEditingController = TextEditingController(text: "");
    super.initState();
  }
}
