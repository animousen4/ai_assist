import 'dart:io';

import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:ai_assist/model/db/c/message_db.dart';
//import 'package:ai_assist/model/db/template_db.dart';
import 'package:ai_assist/view/logic/chat_manager/chat_manager.dart';
import 'package:ai_assist/view/routes/routes.dart';
import 'package:ai_assist/view/theme/app_theme.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  final appRouter = AppRouter();
  final chatManager = ChatManager(ChatGptService.create(client(
      AuthorizationSericeV1(
          "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"))));

  runApp(MyApp(
    appRouter: appRouter,
    chatManager: chatManager,
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final ChatManager chatManager;
  const MyApp({super.key, required this.appRouter, required this.chatManager});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => MessageDatabase(),
          dispose: (context, value) => value.close(),
        ),
        Provider<ChatManager>.value(value: chatManager)
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemeManager.dark,
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}
