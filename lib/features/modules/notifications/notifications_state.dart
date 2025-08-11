part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final Map<String, int>
      unreadCount;
  final NotificationsEntities? currentNoti;
  final bool isWebSocketConnected;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.unreadCount = const {},
    this.currentNoti,
    this.isWebSocketConnected = false,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    Map<String, int>? unreadCount,
    NotificationsEntities? currentNoti,
    bool? isWebSocketConnected,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      unreadCount: unreadCount ?? this.unreadCount,
      currentNoti: currentNoti ?? this.currentNoti,
      isWebSocketConnected: isWebSocketConnected ?? this.isWebSocketConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [unreadCount, currentNoti, isWebSocketConnected, isLoading, error];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial() : super();
}
