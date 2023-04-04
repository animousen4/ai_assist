import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:ai_assist/view/logic/chat_manager/chat_manager.dart';
import 'package:ai_assist/view/widget/chat_header_sliver.dart';
import 'package:ai_assist/view/widget/icon_label.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/chat_bloc/chat_bloc.dart';
import '../../logic/selection_chat_bloc/selection_chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, @PathParam('chatId') required this.chatId});
  final int chatId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textEditingController;
  late final ScrollController _scrollController;
  late TapDownDetails tdDetails;
  ChatGptRole chatGptRole = ChatGptRole.user;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(
              chatId: widget.chatId,
              messageDatabase: context.read<MessageDatabase>(),
              chatGptService: context.read<ChatManager>().chatGptService),
        ),
        BlocProvider(
          create: (context) => SelectionChatBloc(
              messageDatabase: context.read<MessageDatabase>()),
        ),
      ],
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
            actions: [
              BlocBuilder<SelectionChatBloc, SelectionChatState>(
                builder: (context, state) {
                  if (state.isSelectionMode) {
                    return PopupMenuButton<String>(
                        onSelected: (value) {
                          var b = context.read<SelectionChatBloc>();
                          switch (value) {
                            case "delete":
                              b.add(DeleteSelectedMessages());
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: IconLabel(
                                    icon: Icon(Icons.delete_outline),
                                    text: Text("Delete")),
                                value: "delete",
                              )
                            ]);
                  }
                  return SizedBox();
                },
              )
            ],
          ),
          body: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) async {
              if (state.error != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                        SnackBar(content: Text("Error: ${state.error}")))
                    .closed
                    .then(
                        (value) => context.read<ChatBloc>().add(ClearError()));
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
                        ? Text("Write a message with role to create template!")
                        : Text(
                            "No messages! Write anything to start up a dialog!"),
                  );
                } else {
                  final msgs = state.extendedChat!.messages.reversed.toList();
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return BlocBuilder<SelectionChatBloc, SelectionChatState>(
                        builder: (context, selectionState) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            color: selectionState.selectedMessagesId
                                    .contains(msgs[index].id)
                                ? Colors.white.withOpacity(0.3)
                                : Colors.transparent,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: index == 0 ? 70 : 0),
                              child: GestureDetector(
                                onLongPress: () {
                                  context
                                      .read<SelectionChatBloc>()
                                      .add(SelectMessage(msgs[index].id));
                                },
                                onTapDown: (details) => tdDetails = details,
                                onTap: () async {
                                  Logger().d("onTd");
                                  if (selectionState.isSelectionMode) {
                                    context
                                        .read<SelectionChatBloc>()
                                        .add(SelectMessage(msgs[index].id));
                                  } else {
                                    var res = showMenu<String>(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            tdDetails.globalPosition.dx,
                                            tdDetails.globalPosition.dy,
                                            MediaQuery.of(context).size.width -
                                                tdDetails.globalPosition.dx,
                                            MediaQuery.of(context).size.height -
                                                tdDetails.globalPosition.dy),
                                        items: [
                                          PopupMenuItem(
                                              value: "delete",
                                              child: IconLabel(
                                                  icon: Icon(
                                                      Icons.delete_outline),
                                                  text: Text("Delete"))),
                                          PopupMenuItem(
                                              value: "edit",
                                              child: IconLabel(
                                                  icon:
                                                      Icon(Icons.edit_outlined),
                                                  text: Text("Edit")))
                                        ]);
                                    // switch (res) {
                                    //   case value:

                                    //     break;
                                    //   default:
                                    // }
                                  }
                                },
                                child: BubbleNormal(
                                  text: msgs[index].content,
                                  isSender:
                                      msgs[index].role == ChatGptRole.user.name,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
                    child: BlocBuilder<SelectionChatBloc, SelectionChatState>(
                      builder: (context, selectionState) {
                        return TextFormField(
                          maxLines: null,
                          controller: textEditingController,
                          //onFieldSubmitted: (v) => _submitMessage(context),
                          autofocus: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (selectionState.isModificationMode) {
                                    // PROCEESS
                                    //context.read<SelectionChatBloc>();
                                  } else {
                                    //_submitMessage(context);
                                    context.read<ChatBloc>().add(
                                            AddMessageEvent([
                                          MessageAdapter(
                                              content:
                                                  textEditingController.text,
                                              role: chatGptRole)
                                        ],));

                                    setState(() {
                                      textEditingController.text = "";
                                    });
                                  }
                                },
                                icon: Icon(Icons.send)),
                          ),
                        );
                      },
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
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    textEditingController = TextEditingController(text: "");
    super.initState();
  }
}
