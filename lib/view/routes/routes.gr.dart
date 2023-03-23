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
    ChatPageRoute.name: (routeData) {
      final args = routeData.argsAs<ChatPageRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ChatPage(
          key: args.key,
          isTemplate: args.isTemplate,
          n: args.n,
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
          ChatPageRoute.name,
          path: '/chat/:n',
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
/// [ChatPage]
class ChatPageRoute extends PageRouteInfo<ChatPageRouteArgs> {
  ChatPageRoute({
    Key? key,
    required bool isTemplate,
    required int n,
  }) : super(
          ChatPageRoute.name,
          path: '/chat/:n',
          args: ChatPageRouteArgs(
            key: key,
            isTemplate: isTemplate,
            n: n,
          ),
          rawPathParams: {'n': n},
        );

  static const String name = 'ChatPageRoute';
}

class ChatPageRouteArgs {
  const ChatPageRouteArgs({
    this.key,
    required this.isTemplate,
    required this.n,
  });

  final Key? key;

  final bool isTemplate;

  final int n;

  @override
  String toString() {
    return 'ChatPageRouteArgs{key: $key, isTemplate: $isTemplate, n: $n}';
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
