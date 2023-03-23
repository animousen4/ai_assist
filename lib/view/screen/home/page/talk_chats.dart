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
  final logger = Logger();
  late int curBlocIndex;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalkManagerBloc, TalkManagerState>(
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context2, index) {
            return ListTile(
              title: Text("${state.chats[index].name}"),
              leading: CircleAvatar(
                child: Text("$index"),
              ),
              onTap: () {
                logger.i(context.router.current);
                context.router.push(ChatPageRoute(
                    n: index, isTemplate: widget.managerBloc.isTempl));
                //context.navigateTo();
              },
              subtitle: Text("Nothing"),
            );
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
