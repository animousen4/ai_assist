import 'package:ai_assist/model/db/c/message_db.dart';

import 'package:ai_assist/view/routes/routes.dart';
import 'package:ai_assist/view/screen/chat/chat_page.dart';
import 'package:ai_assist/view/screen/home/page/talk_chats.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/logic/selection_bloc/selection_bloc.dart';
import '../../../model/logic/talk_manager_bloc/talk_manager_bloc.dart';

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
                      return PopupMenuButton<String>(
                          onSelected: (value) async {
                            switch (value) {
                              case "toTempl":
                                context
                                    .read<SelectionBloc>()
                                    .add(MakeCopyToTemplates());
                                break;

                              case "toTalk":
                                context.read<SelectionBloc>().add(MakeCopy());
                                break;

                              case "rename":
                                String newName = "";
                                await showDialog(
                                    context: context,
                                    builder: (contextt) => AlertDialog(
                                          title: Text("New name"),
                                          content: TextFormField(
                                            onChanged: (t) => newName = t,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<SelectionBloc>()
                                                      .add(Rename(newName));
                                                  context.popRoute();
                                                },
                                                child: Text("Ok"))
                                          ],
                                        ));
                                break;

                              case "delete":
                                context
                                    .read<SelectionBloc>()
                                    .add(DeleteChats());
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline),
                                      SizedBox(width: 10),
                                      Text("Delete")
                                    ],
                                  ),
                                  value: "delete",
                                ),
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.save_outlined),
                                        SizedBox(width: 10),
                                        Text("To templates")
                                      ],
                                    ),
                                    value: "toTempl",
                                  ),
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.chat_outlined,
                                        ),
                                        SizedBox(width: 10),
                                        Text("To talks")
                                      ],
                                    ),
                                    value: "toTalk",
                                  ),
                                if (state.isSingleSelection)
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                        ),
                                        SizedBox(width: 10),
                                        Text("Rename")
                                      ],
                                    ),
                                    value: "rename",
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
        ..add(LoadChats())
        ..add(AutoOpenChat()),
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
