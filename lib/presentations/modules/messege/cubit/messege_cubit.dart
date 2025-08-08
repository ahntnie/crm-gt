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
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import '../../../../domains/entities/messege/messege_entities.dart';

part 'messege_state.dart';

class MessegeCubit extends Cubit<MessegeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  final _useCase = getIt.get<MessegeUseCase>();
  final _imagePicker = ImagePicker();
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

  /// Chọn ảnh từ thư viện ảnh
  Future<void> selectImagesFromGallery() async {
    try {
      emit(state.copyWith(isLoading: true, selectedFiles: state.selectedFiles));
      
      final List<XFile> pickedImages = await _imagePicker.pickMultiImage(
        imageQuality: 80, // Giảm chất lượng để giảm kích thước
        maxWidth: 1920, // Giới hạn chiều rộng
        maxHeight: 1920, // Giới hạn chiều cao
      );
      
      if (pickedImages.isNotEmpty) {
        final List<File> imageFiles = [];
        
        for (final xFile in pickedImages) {
          try {
            final file = File(xFile.path);
            if (await file.exists()) {
              // Kiểm tra kích thước file
              final fileSize = await file.length();
              if (fileSize <= 10 * 1024 * 1024) { // 10MB limit
                imageFiles.add(file);
              } else {
                print('File ${xFile.name} quá lớn: ${fileSize} bytes');
              }
            }
          } catch (e) {
            print('Lỗi xử lý ảnh ${xFile.name}: $e');
          }
        }
        
        if (imageFiles.isNotEmpty) {
          emit(state.copyWith(
            selectedFiles: [...state.selectedFiles, ...imageFiles],
            isLoading: false,
          ));
        } else {
          emit(state.copyWith(
            error: 'Không có ảnh nào được chọn hoặc ảnh quá lớn',
            isLoading: false,
            selectedFiles: state.selectedFiles,
          ));
        }
      } else {
        emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Lỗi chọn ảnh từ thư viện: $e', 
        isLoading: false,
        selectedFiles: state.selectedFiles
      ));
    }
  }

  /// Chọn file từ thiết bị (tất cả loại file)
  Future<void> selectFiles() async {
    try {
      emit(state.copyWith(isLoading: true, selectedFiles: state.selectedFiles));
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
        withData: true, // Đảm bảo bytes có sẵn trên iOS
      );
      
      if (result != null && result.files.isNotEmpty) {
        final List<File> pickedFiles = [];
        
        for (final platformFile in result.files) {
          try {
            File? file;
            
            // Ưu tiên sử dụng path nếu có
            if (platformFile.path != null && platformFile.path!.isNotEmpty) {
              file = File(platformFile.path!);
              if (await file.exists()) {
                pickedFiles.add(file);
                continue;
              }
            }
            
            // Nếu không có path hoặc file không tồn tại, sử dụng bytes
            if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
              final tempDir = Directory.systemTemp;
              final fileName = platformFile.name.isNotEmpty 
                  ? platformFile.name 
                  : 'file_${DateTime.now().millisecondsSinceEpoch}';
              final tempPath = path.join(tempDir.path, fileName);
              final tempFile = File(tempPath);
              
              await tempFile.writeAsBytes(platformFile.bytes!, flush: true);
              pickedFiles.add(tempFile);
            }
          } catch (e) {
            print('Lỗi xử lý file ${platformFile.name}: $e');
            // Tiếp tục với file tiếp theo thay vì dừng toàn bộ
          }
        }
        
        if (pickedFiles.isNotEmpty) {
          emit(state.copyWith(
            selectedFiles: [...state.selectedFiles, ...pickedFiles],
            isLoading: false,
          ));
        } else {
          emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
        }
      } else {
        emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Lỗi chọn file: $e', 
        isLoading: false,
        selectedFiles: state.selectedFiles
      ));
    }
  }

  void clearSelectedFiles() {
    emit(state.copyWith(selectedFiles: []));
  }

  Future<void> onTapSendMessege() async {
    if ((state.messege?.isEmpty ?? true) && state.selectedFiles.isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true, selectedFiles: state.selectedFiles));
      
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
          'type': 'message',
          'dir_id': threadId,
        };
        
        if (_webSocketChannel != null && _webSocketChannel!.sink != null) {
          _webSocketChannel!.sink.add(jsonEncode(messegeJson));
        }
      }

      // Gửi các file tuần tự để tránh quá tải
      for (final file in state.selectedFiles) {
        try {
          if (await file.exists()) {
            final encoded = await _encodeFileToBase64Safe(file.path);
            if (encoded != null) {
              final newMessege = MessegeEntities(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                threadId: threadId,
                userId: userId,
                messege: '',
                sentAt: timestamp,
                userName: userName,
                fileName: path.basename(file.path),
                fileUrl: file.path,
                fileType: _getFileType(file),
              );
              final fileJson = {
                ...newMessege.toJson(),
                'type': 'message',
                'dir_id': threadId,
                'file_data': encoded,
              };
              
              if (_webSocketChannel != null && _webSocketChannel!.sink != null) {
                _webSocketChannel!.sink.add(jsonEncode(fileJson));
              }
            }
          }
        } catch (e) {
          print('Lỗi gửi file ${file.path}: $e');
          // Tiếp tục với file tiếp theo
        }
      }

      messegeController.clear();
      emit(state.copyWith(
        messege: '', 
        selectedFiles: [],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Gửi tin nhắn thất bại: $e',
        isLoading: false,
      ));
    }
  }

  // Hàm xử lý file an toàn hơn
  Future<String?> _encodeFileToBase64Safe(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('File không tồn tại: $filePath');
        return null;
      }
      
      final fileSize = await file.length();
      // Giới hạn kích thước file (10MB)
      if (fileSize > 10 * 1024 * 1024) {
        print('File quá lớn: ${fileSize} bytes');
        return null;
      }
      
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Lỗi encode file $filePath: $e');
      return null;
    }
  }

  String _getFileType(File file) {
    final extension = path.extension(file.path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
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
