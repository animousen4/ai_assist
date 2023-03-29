import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:ai_assist/view/logic/chat_manager/chat_manager.dart';
import 'package:ai_assist/view/logic/impl/addable.dart';
import 'package:ai_assist/view/logic/talk_manager_bloc/talk_manager_bloc.dart';
import 'package:ai_assist/view/routes/routes.dart';
import 'package:ai_assist/view/screen/chat/chat_page.dart';
import 'package:ai_assist/view/screen/home/page/talk_chats.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/db/c/template_db.dart';
import '../../logic/chat_bloc/chat_bloc.dart';
import '../../logic/selection_bloc/selection_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  late final List<TalkManagerBloc> blocList;
  late int curBlocIndex;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SelectionBloc(messageDatabase: context.read<MessageDatabase>()),
      child: AutoTabsRouter.tabBar(
        routes: [
          TalkChatsPageRoute(managerBloc: blocList[0]),
          TalkChatsPageRoute(managerBloc: blocList[1])
        ],
        builder: (context, child, tabController) {
          curBlocIndex = tabController.index;
          return Scaffold(
            appBar: AppBar(
              title: Text("Client"),
              bottom: TabBar(
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Talks"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Templates"),
                  )
                ],
                controller: tabController,
              ),
              actions: [
                BlocBuilder<SelectionBloc, SelectionState>(
                  builder: (context, state) {
                    if (state.isSelectionMode) {
                      return IconButton(
                          onPressed: () {
                            context.read<SelectionBloc>().add(DeleteChats());
                          },
                          icon: Icon(Icons.delete));
                    }
                    return SizedBox();
                  },
                ),
                BlocBuilder<SelectionBloc, SelectionState>(
                  builder: (context, state) {
                    if (state.isSelectionMode) {
                      return IconButton(
                          onPressed: () {
                            context.read<SelectionBloc>().add(MakeCopy());
                          },
                          icon: Icon(Icons.copy_all));
                    }
                    return SizedBox();
                  },
                ),
                BlocBuilder<SelectionBloc, SelectionState>(
                  builder: (context, state) {
                    if (state.isSelectionMode) {
                      return PopupMenuButton(
                          itemBuilder: (context) => [
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Text("To templates"),
                                    onTap: () {
                                      context
                                          .read<SelectionBloc>()
                                          .add(MakeCopyToTemplates());
                                    },
                                  ),
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Text("To talks"),
                                    onTap: () {
                                      context
                                          .read<SelectionBloc>()
                                          .add(MakeCopy());
                                    },
                                  ),
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Text("Rename"),
                                    onTap: () async {
                                      String newName = "";
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("New name"),
                                                content: TextFormField(
                                                  onChanged: (t) => newName = t,
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                SelectionBloc>()
                                                            .add(Rename(
                                                                newName));
                                                      },
                                                      child: Text("Ok"))
                                                ],
                                              ));
                                    },
                                  )
                              ]);
                    }
                    return SizedBox();
                  },
                )
              ],
            ),
            body: child,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                String text = "";
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Write a name of chat"),
                          content: TextFormField(
                            onChanged: (t) => text = t,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  blocList[curBlocIndex].add(AddChat(text));
                                  context.popRoute();
                                },
                                child: Text("OK"))
                          ],
                        ));
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    curBlocIndex = 0;
    blocList = [
      TalkManagerBloc(
          isTempl: false, messageDatabase: context.read<MessageDatabase>())
        ..add(LoadChats()),
      TalkManagerBloc(
          isTempl: true, messageDatabase: context.read<MessageDatabase>())
        ..add(LoadChats())
    ];
    // talkm = TalkManagerBloc(
    //     isTempl: false, messageDatabase: context.read<MessageDatabase>())
    //   ..add(LoadChats());
    // templ = TalkManagerBloc(
    //     isTempl: true, messageDatabase: context.read<MessageDatabase>())
    //   ..add(LoadChats());
    super.initState();
  }
}
