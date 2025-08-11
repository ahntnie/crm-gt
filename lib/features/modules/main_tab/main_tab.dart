import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:core/core.dart';
import 'package:crm_gt/apps/app_cubit.dart';
import 'package:crm_gt/features/modules/home/home_screen.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:crm_gt/widgets/swipe_back_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit/main_tab_cubit.dart';

part 'components/main_tab_view.dart';

class MainTab {
  static final List<StatefulShellBranch> _routes = [
    StatefulShellBranch(routes: [
      GoRoute(
        path: Routes.home.path,
        pageBuilder: (context, state) => getPage(
          page: const HomeScreen(),
          state: state,
        ),
      ),
    ]),
  ];

  static RouteBase getRoute() => StatefulShellRoute.indexedStack(
        branches: _routes,
        pageBuilder: (context, state, navigationShell) => getPage(
          page: BlocProvider(
            create: (context) => MainTabCubit(),
            child: MainTabView(navigationShell),
          ),
          state: state,
        ),
      );

  static void jumpTo(Routes route) => AppNavigator.go(route);
}
