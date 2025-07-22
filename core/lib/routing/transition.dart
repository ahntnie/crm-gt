part of core;

class IOSPageRoute<T> extends MaterialPageRoute<T> {
  IOSPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return const CupertinoPageTransitionsBuilder()
        .buildTransitions(this, context, animation, secondaryAnimation, child);
  }
}

Page getPage({
  required Widget page,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
      key: state.pageKey,
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const ZoomPageTransitionsBuilder()
            .buildTransitions(null, context, animation, secondaryAnimation, child);
      });
}
