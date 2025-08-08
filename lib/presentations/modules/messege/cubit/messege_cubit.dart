import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/domains/usecases/messege/messege_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../domains/entities/messege/messege_entities.dart';

part 'messege_state.dart';

class MessegeCubit extends Cubit<MessegeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  final _useCase = getIt.get<MessegeUseCase>();
  TextEditingController messegeController = TextEditingController();
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;
  MessegeCubit() : super(MessegeInitial());

  Future<void> getInit(String idDir) async {
    try {
      emit(state.copyWith(isLoading: true, selectedFiles: state.selectedFiles));
      List<MessegeEntities> listData = await _useCase.getChatThreadByIdDir(idDir);
      await _initWebSocket(idDir);
      emit(state.copyWith(
        listMessege: listData,
        idDir: idDir,
        isLoading: false,
        selectedFiles: state.selectedFiles,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Khởi tạo cuộc trò chuyện thất bại: $e',
        isLoading: false,
        selectedFiles: state.selectedFiles,
      ));
    }
  }

  Future<void> _initWebSocket(String idDir) async {
    try {
      await _webSocketSubscription?.cancel();
      _webSocketSubscription = null;
      _webSocketChannel?.sink.close();
      _webSocketChannel = null;
      const String wsUrl = 'ws://crm.gtglobal.com.vn:721';
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await _webSocketChannel!.ready;
      _webSocketChannel!.sink.add(jsonEncode({
        'thread_id': idDir,
        'type': 'init',
        'user_id': 1,
      }));
      _webSocketSubscription = _webSocketChannel!.stream.listen(
        (data) {
          try {
            final newMessege = MessegeEntities.fromJson(data is String ? jsonDecode(data) : data);
            final updatedList = List<MessegeEntities>.from(state.listMessege)..add(newMessege);
            emit(state.copyWith(
              listMessege: updatedList,
              isConnected: true,
              error: null,
              selectedFiles: state.selectedFiles,
            ));
          } catch (e) {
            emit(
                state.copyWith(error: 'Lỗi xử lý dữ liệu: $e', selectedFiles: state.selectedFiles));
          }
        },
        onError: (error) {
          emit(state.copyWith(
            error: 'Lỗi kết nối WebSocket: $error',
            isConnected: false,
            selectedFiles: state.selectedFiles,
          ));
        },
        onDone: () {
          emit(state.copyWith(
            error: 'Kết nối WebSocket đã đóng',
            isConnected: false,
            selectedFiles: state.selectedFiles,
          ));
        },
      );

      // Cập nhật trạng thái kết nối
      emit(state.copyWith(
        isConnected: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
          error: 'Không thể kết nối WebSocket: $e',
          isConnected: false,
          selectedFiles: state.selectedFiles));
    }
  }

  void messegeChanged(String value) {
    emit(state.copyWith(messege: value, selectedFiles: state.selectedFiles));
  }

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
      );
      if (result != null) {
        List<File> files = result.files.map((file) => File(file.path!)).toList();
        emit(state.copyWith(selectedFiles: files));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Lỗi chọn file: $e', selectedFiles: state.selectedFiles));
    }
  }

  void clearSelectedFiles() {
    emit(state.copyWith(selectedFiles: []));
  }

  Future<void> onTapSendMessege() async {
    if ((state.messege?.isEmpty ?? true) && state.selectedFiles.isEmpty) return;

    try {
      final timestamp = DateTime.now().toIso8601String();
      final userId = getCurrentUserId();
      final userName = getCurrentUserName();
      final threadId = state.idDir;

      // Gửi tin nhắn văn bản nếu có
      if (state.messege != null && state.messege!.isNotEmpty) {
        final newMessege = MessegeEntities(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          threadId: threadId,
          userId: userId,
          messege: state.messege!,
          sentAt: timestamp,
          userName: userName,
        );
        final messegeJson = {
          ...newMessege.toJson(),
          "type": "message",
          "dir_id": threadId,
        };
        _webSocketChannel?.sink.add(jsonEncode(messegeJson));
      }

      // Gửi các file song song (tối ưu tốc độ)
      await Future.wait(state.selectedFiles.map((file) async {
        final encoded = await compute(_encodeFileToBase64, file.path);
        final newMessege = MessegeEntities(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          threadId: threadId,
          userId: userId,
          messege: '',
          sentAt: timestamp,
          userName: userName,
          fileName: file.path.split('/').last,
          fileUrl: file.path,
          fileType: _getFileType(file),
        );
        final fileJson = {
          ...newMessege.toJson(),
          "type": "message",
          "dir_id": threadId,
          "file_data": encoded,
        };
        _webSocketChannel?.sink.add(jsonEncode(fileJson));
      }));

      messegeController.clear();
      emit(state.copyWith(messege: '', selectedFiles: []));
    } catch (e) {
      emit(state.copyWith(error: 'Gửi tin nhắn thất bại: $e'));
    }
  }

// Hàm xử lý file ngoài isolate
  Future<String> _encodeFileToBase64(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  String _getFileType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      default:
        return 'application/octet-stream';
    }
  }

  String getCurrentUserId() => AppSP.get('account');
  String getCurrentUserName() => 'Test';

  Future<void> getUserFromChatThread(String idDir) async {
    try {
      emit(state.copyWith(isLoading: true));
      List<UserEntities> users = await _useCase.getUserFromChatThread(idDir);
      emit(state.copyWith(listUsers: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: 'Lấy danh sách thành viên thất bại: $e',
        isLoading: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    print('Hủy MessegeCubit');
    await _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    messegeController.dispose();
    return super.close();
  }
}
