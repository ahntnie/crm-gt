import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/domains/usecases/message/message_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../domains/entities/message/message_entities.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  final _useCase = getIt.get<MessageUseCase>();
  TextEditingController messageController = TextEditingController();
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;

  MessageCubit() : super(MessageInitial());

  Future<void> getInit(String idDir) async {
    print('Gọi getInit với idDir: $idDir');
    try {
      emit(state.copyWith(isLoading: true));
      List<MessageEntities> listData = await _useCase.getChatThreadByIdDir(idDir);
      await _initWebSocket(idDir);
      emit(state.copyWith(
        listMessage: listData,
        idDir: idDir,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Khởi tạo cuộc trò chuyện thất bại: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _initWebSocket(String idDir) async {
    try {
      // Hủy subscription cũ nếu có
      await _webSocketSubscription?.cancel();
      _webSocketSubscription = null;
      _webSocketChannel?.sink.close();
      _webSocketChannel = null;

      // Khởi tạo kết nối WebSocket
      const String wsUrl = 'ws://crm.gtglobal.com.vn:721';
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Chờ kết nối sẵn sàng
      await _webSocketChannel!.ready;
      print('Đã kết nối WebSocket thành công');

      // Gửi tin nhắn khởi tạo
      _webSocketChannel!.sink.add(jsonEncode({
        'thread_id': idDir,
        'type': 'init',
        'user_id': 1,
      }));

      // Thiết lập lắng nghe tin nhắn
      _webSocketSubscription = _webSocketChannel!.stream.listen(
        (data) {
          print('Nhận dữ liệu WebSocket: $data');
          try {
            final newMessage = MessageEntities.fromJson(data is String ? jsonDecode(data) : data);
            final updatedList = List<MessageEntities>.from(state.listMessage)..add(newMessage);
            emit(state.copyWith(
              listMessage: updatedList,
              isConnected: true,
              error: null,
            ));
          } catch (e) {
            print('Lỗi parse dữ liệu: $e');
            emit(state.copyWith(error: 'Lỗi xử lý dữ liệu: $e'));
          }
        },
        onError: (error) {
          print('Lỗi WebSocket: $error');
          emit(state.copyWith(
            error: 'Lỗi kết nối WebSocket: $error',
            isConnected: false,
          ));
        },
        onDone: () {
          print('WebSocket đã đóng');
          emit(state.copyWith(
            error: 'Kết nối WebSocket đã đóng',
            isConnected: false,
          ));
        },
      );

      // Cập nhật trạng thái kết nối
      emit(state.copyWith(
        isConnected: true,
        error: null,
      ));
    } catch (e) {
      print('Lỗi khởi tạo WebSocket: $e');
      emit(state.copyWith(
        error: 'Không thể kết nối WebSocket: $e',
        isConnected: false,
      ));
    }
  }

  void messageChanged(String value) {
    emit(state.copyWith(message: value));
  }

  Future<void> onTapSendMessage() async {
    if (state.message == null || state.message!.isEmpty) return;

    try {
      final newMessage = MessageEntities(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        threadId: state.idDir,
        userId: getCurrentUserId(),
        message: state.message,
        sentAt: DateTime.now().toIso8601String(),
        userName: getCurrentUserName(),
      );
      final messageJson = {
        ...newMessage.toJson(), // Spread operator để lấy tất cả các trường từ toJson
        "type": "message", // Thêm trường type
      };
      print('hjahaha: ${messageJson}');
      _webSocketChannel?.sink.add(jsonEncode(messageJson));
      // final updatedList = List<MessageEntities>.from(state.listMessage)..add(newMessage);
      // emit(state.copyWith(
      //   listMessage: updatedList,
      //   message: '',
      // ));
      messageController.clear();
    } catch (e) {
      emit(state.copyWith(error: 'Gửi tin nhắn thất bại: $e'));
    }
  }

  String getCurrentUserId() => AppSP.get('account'); // Thay bằng logic thực tế
  String getCurrentUserName() => 'Test'; // Thay bằng logic thực tế

  @override
  Future<void> close() async {
    print('Hủy MessageCubit');
    await _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    messageController.dispose();
    return super.close();
  }
}
