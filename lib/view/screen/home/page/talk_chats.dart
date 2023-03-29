import 'package:ai_assist/view/logic/chat_bloc/chat_bloc.dart';
import 'package:ai_assist/view/logic/talk_manager_bloc/talk_manager_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';

import '../../../logic/chat_manager/chat_manager.dart';
import '../../../routes/routes.dart';

class TalkChatsPage extends StatefulWidget {
  const TalkChatsPage({super.key, required this.managerBloc});

  final TalkManagerBloc managerBloc;
  @override
  State<TalkChatsPage> createState() => _TalkChatsPageState();
}

class _TalkChatsPageState extends State<TalkChatsPage> {
  late final List<PageRouteInfo> routes;
  bool selectMode = false;
  final logger = Logger();
  final List<int> selectedIndexes = [];
  late int curBlocIndex;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalkManagerBloc, TalkManagerState>(
      bloc: widget.managerBloc,
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context2, index) {
            return ListTile(
                title: Text(state.chats[index].name),
                //selectedTileColor: Colors.white.withOpacity(0.2),
                selected: selectedIndexes.contains(index),
                leading: CircleAvatar(
                  backgroundColor: selectedIndexes.contains(index)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inversePrimary,
                  child: Text("$index"),
                ),
                onTap: () {
                  if (selectMode) {
                    if (selectedIndexes.contains(index)) {
                      setState(() {
                        selectedIndexes.remove(index);
                      });
                    } else {
                      setState(() {
                        selectedIndexes.add(index);
                      });
                    }
                  } else {
                    logger.i(context.router.current);
                    context.router
                        .push(ChatPageRoute(chatId: state.chats[index].chatId));
                  }
                  //context.navigateTo();
                },
                onLongPress: () {
                  if (!selectMode) {
                    setState(() {
                      selectedIndexes.add(index);
                      selectMode = true;
                    });
                  } else {}
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
  }

  @override
  void initState() {
    super.initState();
  }
}
