// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'routes.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: HomeScreen(key: args.key),
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    ChatPageRoute.name: (routeData) {
      final args = routeData.argsAs<ChatPageRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ChatPage(
          key: args.key,
          chatId: args.chatId,
          sharedPreferences: args.sharedPreferences,
        ),
      );
    },
    TalkChatsPageRoute.name: (routeData) {
      final args = routeData.argsAs<TalkChatsPageRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: TalkChatsPage(
          key: args.key,
          managerBloc: args.managerBloc,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/home',
          fullMatch: true,
        ),
        RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
          children: [
            RouteConfig(
              TalkChatsPageRoute.name,
              path: 'talks',
              parent: HomeScreenRoute.name,
            )
          ],
        ),
        RouteConfig(
          SettingsScreenRoute.name,
          path: '/settings',
        ),
        RouteConfig(
          ChatPageRoute.name,
          path: '/chat/:chatId',
        ),
      ];
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeScreenRoute.name,
          path: '/home',
          args: HomeScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';
}

class HomeScreenRouteArgs {
  const HomeScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SettingsScreen]
class SettingsScreenRoute extends PageRouteInfo<void> {
  const SettingsScreenRoute()
      : super(
          SettingsScreenRoute.name,
          path: '/settings',
        );

  static const String name = 'SettingsScreenRoute';
}

/// generated route for
/// [ChatPage]
class ChatPageRoute extends PageRouteInfo<ChatPageRouteArgs> {
  ChatPageRoute({
    Key? key,
    required int chatId,
    required SharedPreferences sharedPreferences,
  }) : super(
          ChatPageRoute.name,
          path: '/chat/:chatId',
          args: ChatPageRouteArgs(
            key: key,
            chatId: chatId,
            sharedPreferences: sharedPreferences,
          ),
          rawPathParams: {'chatId': chatId},
        );

  static const String name = 'ChatPageRoute';
}

class ChatPageRouteArgs {
  const ChatPageRouteArgs({
    this.key,
    required this.chatId,
    required this.sharedPreferences,
  });

  final Key? key;

  final int chatId;

  final SharedPreferences sharedPreferences;

  @override
  String toString() {
    return 'ChatPageRouteArgs{key: $key, chatId: $chatId, sharedPreferences: $sharedPreferences}';
  }
}

/// generated route for
/// [TalkChatsPage]
class TalkChatsPageRoute extends PageRouteInfo<TalkChatsPageRouteArgs> {
  TalkChatsPageRoute({
    Key? key,
    required TalkManagerBloc managerBloc,
  }) : super(
          TalkChatsPageRoute.name,
          path: 'talks',
          args: TalkChatsPageRouteArgs(
            key: key,
            managerBloc: managerBloc,
          ),
        );

  static const String name = 'TalkChatsPageRoute';
}

class TalkChatsPageRouteArgs {
  const TalkChatsPageRouteArgs({
    this.key,
    required this.managerBloc,
  });

  final Key? key;

  final TalkManagerBloc managerBloc;

  @override
  String toString() {
    return 'TalkChatsPageRouteArgs{key: $key, managerBloc: $managerBloc}';
  }
}
