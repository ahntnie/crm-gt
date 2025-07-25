import 'package:core/core.dart';
import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/presentations/modules/authentication/login/login_screen.dart';
import 'package:crm_gt/presentations/modules/main_tab/main_tab.dart';
import 'package:crm_gt/presentations/modules/message/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  splash('/'),
  login('/login'),
  home('/home'),
  message('/message'),
  ;

  final String path;

  const Routes(this.path);
}

final class _RouteConfig {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.splash.path,
      pageBuilder: (context, state) => getPage(
        page: BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginScreen(),
        ),
        state: state,
      ),
    ),
    GoRoute(
      path: Routes.login.path,
      pageBuilder: (context, state) => getPage(
        page: const LoginScreen(),
        state: state,
      ),
    ),
    GoRoute(
        path: Routes.message.path,
        pageBuilder: (context, state) {
          String data = state.extra as String;
          return getPage(
            page: MessageScreen(
              idDir: data,
            ),
            state: state,
          );
        }),
    MainTab.getRoute(),
  ];

  static final ValueNotifier<RoutingConfig> config = ValueNotifier(RoutingConfig(routes: routes));

  static final GoRouter router = GoRouter.routingConfig(
    routingConfig: config,
    navigatorKey: AppNavigator.navigatorKey,
  );

  static String of(Routes route) => route.path;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final GoRouter router = _RouteConfig.router;

  static String get initialRoute => _RouteConfig.of(Routes.splash);

  static void addRoutes(List<RouteBase> routes) {
    _RouteConfig.config.value = RoutingConfig(
      routes: _RouteConfig.routes + routes,
    );
  }

  static void replaceRoutes(List<RouteBase> routes) {
    _RouteConfig.config.value = RoutingConfig(
      routes: routes,
    );
  }

  static Future pushNamed<T extends Object>(String route, [T? arguments]) async =>
      context.push(route, extra: arguments);

  static void replaceNamed<T extends Object>(String route, [T? arguments]) =>
      context.replace(route, extra: arguments);

  static void goNamed<T extends Object>(String route, [T? arguments]) =>
      context.go(route, extra: arguments);

  static Future push<T extends Object>(Routes route, [T? arguments]) async =>
      pushNamed(_RouteConfig.of(route), arguments);

  static void replace<T extends Object>(Routes route, [T? arguments]) =>
      replaceNamed(_RouteConfig.of(route), arguments);

  static void go<T extends Object>(Routes route, [T? arguments]) =>
      goNamed(_RouteConfig.of(route), arguments);

  static void pop<T extends Object>([T? result]) => context.pop(result);

  static BuildContext get context {
    if (navigatorKey.currentContext == null) {
      throw Exception('Navigator is not initialized');
    }

    return navigatorKey.currentContext!;
  }
}
