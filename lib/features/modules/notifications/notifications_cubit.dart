import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/notifications/notifications_entities.dart';
import 'package:crm_gt/domains/usecases/notifications/notification_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsUsecase notiUseCase = getIt.get<NotificationsUsecase>();
  late WebSocketChannel channel;
  StreamSubscription? _wsSubscription;

  NotificationsCubit() : super(const NotificationsState()) {
    connectWebSocket();
  }

  void connectWebSocket() {
    print('Connecting to WebSocket for user: ${AppSP.get('account')}');
    channel = WebSocketChannel.connect(
      Uri.parse('ws://crm.gtglobal.com.vn:721?user_id=${AppSP.get('account')}'),
    );

    channel.sink.add(jsonEncode({
      'type': 'auth',
      'user_id': AppSP.get('account'),
    }));

    _wsSubscription = channel.stream.listen(
      (data) {
        emit(state.copyWith(isWebSocketConnected: true));
        _handleWebSocketData(data);
      },
      onError: (error) {
        print("WebSocket error: $error");
        emit(state.copyWith(isWebSocketConnected: false, error: error.toString()));
        _reconnectWebSocket();
      },
      onDone: () {
        print("WebSocket closed, reconnecting...");
        emit(state.copyWith(isWebSocketConnected: false));
        _reconnectWebSocket();
      },
    );
  }

  void _reconnectWebSocket() {
    const maxRetries = 5;
    int retryCount = 0;
    Future.delayed(Duration(seconds: 2 * (retryCount + 1)), () {
      if (retryCount < maxRetries && !isClosed) {
        connectWebSocket();
        retryCount++;
      } else {
        print("Max retries reached. WebSocket connection failed.");
      }
    });
  }

  Future<void> getUnreadNotification(String id) async {
    if (id.isEmpty) {
      print('getUnreadNotification: Invalid ID');
      emit(state.copyWith(error: 'Invalid ID'));
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      print('Fetching unread notifications from API for threadId: $id');
      final currentNoti = await notiUseCase.getUnreadNotification(id);
      final newMap = Map<String, int>.from(state.unreadCount);

      if (currentNoti.dirType == 'parent' || currentNoti.dirType == 'child') {
        newMap[id] = currentNoti.unreadCount ?? 0;
      }

      print('Updated unreadCount: $newMap');
      emit(state.copyWith(
        currentNoti: currentNoti,
        unreadCount: newMap,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      print('Error fetching notifications for threadId $id: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to fetch notifications: $e',
      ));
    }
  }

  void _handleWebSocketData(String rawData) {
    if (isClosed) return;
    final data = jsonDecode(rawData);
    print("🟡 WS DATA: $data");

    if (data['type'] == 'unread_count') {
      final threadId = data['thread_id'].toString();
      final count = data['count'] ?? 0;
      updateUnread(threadId, count);
    } else if (data['type'] == 'unread_parent') {
      final parentDirId = data['parent_dir_id'].toString();
      final count = data['total_unread'] ?? 0;
      updateUnread(parentDirId, count);
    }
  }

  void updateUnread(String key, int count) {
    if (isClosed || key.isEmpty || count < 0) return;
    final newMap = Map<String, int>.from(state.unreadCount);
    newMap[key] = count;
    print('WebSocket updated unreadCount: $newMap');
    emit(state.copyWith(unreadCount: newMap));
  }

  void resetUnread(String threadId) {
    if (isClosed) return;
    final newMap = Map<String, int>.from(state.unreadCount);
    newMap[threadId] = 0;
    emit(state.copyWith(unreadCount: newMap));

    final markReadPayload = {
      'type': 'mark_read',
      'user_id': AppSP.get('account'),
      'thread_id': threadId,
    };

    print("📤 Sending mark_read: $markReadPayload");
    channel.sink.add(jsonEncode(markReadPayload));
  }

  void closeConnection() {
    _wsSubscription?.cancel();
    channel.sink.close();
  }

  @override
  Future<void> close() {
    closeConnection();
    return super.close();
  }
}
