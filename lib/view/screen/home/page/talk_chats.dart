import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/db/c/message_db.dart';
import '../../../../model/logic/selection_bloc/selection_bloc.dart';
import '../../../../model/logic/talk_manager_bloc/talk_manager_bloc.dart';
import '../../../routes/routes.dart';

class TalkChatsPage extends StatefulWidget {
  const TalkChatsPage({super.key, required this.managerBloc});

  final TalkManagerBloc managerBloc;
  @override
  State<TalkChatsPage> createState() => _TalkChatsPageState();
}

class _TalkChatsPageState extends State<TalkChatsPage> {
  late final List<PageRouteInfo> routes;
  final logger = Logger();
  late int curBlocIndex;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TalkManagerBloc, TalkManagerState>(
      bloc: widget.managerBloc,
      listener: (context, state) {
        if (state.toOpenChatId != null) {
          context.router.push(ChatPageRoute(
              chatId: state.toOpenChatId!,
              sharedPreferences: context.read<SharedPreferences>()));
        }
      },
      builder: (context, state) {
        return BlocBuilder<TalkManagerBloc, TalkManagerState>(
          bloc: widget.managerBloc,
          builder: (context, state) {
            return BlocBuilder<SelectionBloc, SelectionState>(
              builder: (context, selectionState) {
                return ListView.builder(
                  itemBuilder: (context2, index) {
                    return ListTile(
                        title: Text(state.chats[index].name),
                        //selectedTileColor: Colors.white.withOpacity(0.2),
                        selected: selectionState.selectedChatIds
                            .contains(state.chats[index].chatId),
                        leading: CircleAvatar(
                          backgroundColor: selectionState.selectedChatIds
                                  .contains(state.chats[index].chatId)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.inversePrimary,
                          child: Text("$index"),
                        ),
                        onTap: () {
                          if (selectionState.isSelectionMode) {
                            context
                                .read<SelectionBloc>()
                                .add(SelectChat(state.chats[index].chatId));
                          } else {
                            logger.i(context.router.current);
                            context.router.push(ChatPageRoute(
                                sharedPreferences:
                                    context.read<SharedPreferences>(),
                                chatId: state.chats[index].chatId));
                          }
                          //context.navigateTo();
                        },
                        onLongPress: () {
                          if (!selectionState.isSelectionMode) {
                            context
                                .read<SelectionBloc>()
                                .add(SelectChat(state.chats[index].chatId));
                          }
                        },
                        subtitle: state.chats[index].messages.isEmpty
                            ? Text(
                                "Empty",
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                "${state.chats[index].messages.last.role}: ${state.chats[index].messages.last.content}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ));
                  },
                  itemCount: state.chats.length,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
