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

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  late final TalkManagerBloc talkm;
  late final TalkManagerBloc templ;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: talkm,
      child: AutoTabsRouter.tabBar(
        routes: [
          TalkChatsPageRoute(managerBloc: talkm),
          TalkChatsPageRoute(managerBloc: templ)
        ],
        builder: (context, child, tabController) {
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
            ),
            body: child,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    talkm = TalkManagerBloc(
        isTempl: false, messageDatabase: context.read<MessageDatabase>())
      ..add(LoadChats());
    templ = TalkManagerBloc(
        isTempl: true, messageDatabase: context.read<TemplateDatabase>())
      ..add(LoadChats());
    super.initState();
  }
}
