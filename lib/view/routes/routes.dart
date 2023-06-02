import 'package:ai_assist/view/screen/home/home_screen.dart';
import 'package:ai_assist/view/screen/chat/chat_page.dart';
import 'package:ai_assist/view/screen/home/page/talk_chats.dart';
import 'package:ai_assist/view/screen/settings/settings_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../model/logic/talk_manager_bloc/talk_manager_bloc.dart';


part 'routes.gr.dart';      
        
@MaterialAutoRouter(                           
  routes: <AutoRoute>[              
    AutoRoute(path: "/home", page: HomeScreen, initial: true, children: [
      AutoRoute(path: "talks", page: TalkChatsPage),
      
    ]),  
    AutoRoute(path: "/settings", page: SettingsScreen),
    AutoRoute(path: "/chat/:chatId", page: ChatPage),   
    
  ],              
)              
// extend the generated private router        
class AppRouter extends _$AppRouter{}        