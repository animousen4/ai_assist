import 'dart:io';

import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:ai_assist/model/logic/settings/settings_bloc.dart';
import 'package:ai_assist/model/service/multi_authorization_service.dart';
//import 'package:ai_assist/model/db/template_db.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'model/logic/chat_manager/chat_manager.dart';

void main() async {
  sqfliteFfiInit();

  final sharedPreferences = await SharedPreferences.getInstance();
  final tokenDatabase = TokenDatabase();
  // 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
  final appRouter = AppRouter();
  final chatManager = ChatManager(
      ChatGptService.create(client(MultiAuthorizationService(tokenDatabase))));

  runApp(MyApp(
    appRouter: appRouter,
    chatManager: chatManager,
    sharedPreferences: sharedPreferences,
    tokenDatabase: tokenDatabase,
  ));
}

/*
curl https://api.openai.com/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer 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" -d "{ model: 'gpt-3.5-turbo', messages: [{role: 'user', content: 'Hello!'}] }"


 */
class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final TokenDatabase tokenDatabase;
  final ChatManager chatManager;
  final SharedPreferences sharedPreferences;
  const MyApp(
      {super.key,
      required this.appRouter,
      required this.chatManager,
      required this.sharedPreferences,
      required this.tokenDatabase});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => MessageDatabase(),
          dispose: (context, value) => value.close(),
        ),
        Provider.value(
          value: tokenDatabase,
        ),
        Provider(create: (context) => sharedPreferences),
        Provider<ChatManager>.value(value: chatManager),
        Provider(create: (context) => SettingsBloc(tokenDatabase: tokenDatabase, prefs: sharedPreferences))
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
