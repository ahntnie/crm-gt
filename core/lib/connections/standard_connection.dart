part of '../core.dart';

@immutable
abstract class StandardConnection<T extends TransportationObject, E extends Object> {
  final SuperAppConn superAppConn;

  const StandardConnection({required this.superAppConn});

  @protected
  Future<void> init(T transportationObject);

  @protected
  List<RouteBase> getRoutes({required GlobalKey<NavigatorState> navigatorKey});

  @protected
  dynamic onEventMiniApp([E? params]) {}
}

mixin SuperAppConn {
  Future<dynamic> onEvent(MiniAppEvent event, [data]);
}

enum MiniAppEvent { refreshToken, logout, createTicket, goDetailTicket }
