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
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../domains/entities/messege/messege_entities.dart';

part 'messege_state.dart';

class MessegeCubit extends Cubit<MessegeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  final _useCase = getIt.get<MessegeUseCase>();
  final _imagePicker = ImagePicker();
  TextEditingController messegeController = TextEditingController();
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;
  Timer? _errorTimer;
  bool _isInitialConnection = true; // Track if this is first connection
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
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(Environments.wsUrl));
      await _webSocketChannel!.ready;
      _webSocketChannel!.sink.add(jsonEncode({
        'thread_id': idDir,
        'type': 'init',
        'user_id': 1,
      }));
      _webSocketSubscription = _webSocketChannel!.stream.listen(
        (data) {
          try {
            final Map<String, dynamic> decodedMap =
                Map<String, dynamic>.from(data is String ? jsonDecode(data) : data);
            final newMessege = MessegeEntities.fromJson(decodedMap);
            final String myUserId = getCurrentUserId().toString();
            List<MessegeEntities> updatedList = List<MessegeEntities>.from(state.listMessege);
            bool reconciled = false;
            int foundIndex = -1;
            final String? echoedLocalId = decodedMap['local_id']?.toString();
            final bool isMyAck = (newMessege.userId == myUserId) || (echoedLocalId != null);
            if (echoedLocalId != null) {
              for (int i = updatedList.length - 1; i >= 0; i--) {
                final m = updatedList[i];
                if (m.localId == echoedLocalId || m.id == echoedLocalId) {
                  foundIndex = i;
                  break;
                }
              }
            }
            if (foundIndex == -1 && (isMyAck || true)) {
              for (int i = updatedList.length - 1; i >= 0; i--) {
                final m = updatedList[i];
                if (m.deliveryStatus != MessageDeliveryStatus.sending) continue;
                if (m.userId?.toString() != myUserId) continue;
                final bool fileMatch = (m.fileName ?? '') == (newMessege.fileName ?? '');
                final bool textMatch = (m.messege ?? '') == (newMessege.messege ?? '');
                if (fileMatch || textMatch) {
                  foundIndex = i;
                  break;
                }
              }
            }

            if (foundIndex != -1) {
              final pending = updatedList[foundIndex];
              final updatedMsg = MessegeEntities(
                id: newMessege.id ?? pending.id,
                threadId: newMessege.threadId ?? pending.threadId,
                userId: newMessege.userId ?? pending.userId,
                messege: newMessege.messege ?? pending.messege,
                sentAt: newMessege.sentAt ?? pending.sentAt,
                userName: newMessege.userName ?? pending.userName,
                fileName: newMessege.fileName ?? pending.fileName,
                fileUrl: newMessege.fileUrl ?? pending.fileUrl,
                fileType: newMessege.fileType ?? pending.fileType,
                localId: pending.localId,
                deliveryStatus: MessageDeliveryStatus.sent,
              );
              updatedList[foundIndex] = updatedMsg;
              reconciled = true;
            }
            if (!reconciled && isMyAck) {
              for (int i = updatedList.length - 1; i >= 0; i--) {
                final m = updatedList[i];
                if (m.userId?.toString() == myUserId &&
                    m.deliveryStatus == MessageDeliveryStatus.sending) {
                  final pending = updatedList[i];
                  final updatedMsg = MessegeEntities(
                    id: newMessege.id ?? pending.id,
                    threadId: newMessege.threadId ?? pending.threadId,
                    userId: newMessege.userId ?? pending.userId,
                    messege: newMessege.messege ?? pending.messege,
                    sentAt: newMessege.sentAt ?? pending.sentAt,
                    userName: newMessege.userName ?? pending.userName,
                    fileName: newMessege.fileName ?? pending.fileName,
                    fileUrl: newMessege.fileUrl ?? pending.fileUrl,
                    fileType: newMessege.fileType ?? pending.fileType,
                    localId: pending.localId,
                    deliveryStatus: MessageDeliveryStatus.sent,
                  );
                  updatedList[i] = updatedMsg;
                  reconciled = true;
                  break;
                }
              }
            }

            if (!reconciled) {
              updatedList.add(newMessege);
            }

            emit(state.copyWith(
              listMessege: updatedList,
              isConnected: true,
              error: null,
              selectedFiles: state.selectedFiles,
            ));
          } catch (e) {
            // Bỏ qua lỗi xử lý dữ liệu nhận được
          }
        },
        onError: (error) {
          emit(state.copyWith(
            isConnected: false,
            selectedFiles: state.selectedFiles,
          ));
          _isInitialConnection = false; // Đánh dấu đã có kết nối trước đó
          _showError('Mất kết nối server. Tin nhắn có thể không được gửi.');
        },
        onDone: () {
          emit(state.copyWith(
            isConnected: false,
            selectedFiles: state.selectedFiles,
          ));
          _isInitialConnection = false; // Đánh dấu đã có kết nối trước đó
          _showError('Mất kết nối server. Đang thử kết nối lại...');
          // Tự động thử kết nối lại sau 3 giây
          Future.delayed(const Duration(seconds: 3), () {
            if (!isClosed && state.idDir != null) {
              _initWebSocket(state.idDir!);
            }
          });
        },
      );

      // Cập nhật trạng thái kết nối
      emit(state.copyWith(
        isConnected: true,
        error: null, // Tự động ẩn error khi kết nối lại thành công
      ));

      // Chỉ hiển thị thông báo "kết nối lại thành công" nếu không phải lần đầu
      if (!_isInitialConnection) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!isClosed) {
            emit(state.copyWith(error: 'connected_success', selectedFiles: state.selectedFiles));
            Timer(const Duration(milliseconds: 500), () {
              if (!isClosed) {
                emit(state.copyWith(error: null, selectedFiles: state.selectedFiles));
              }
            });
          }
        });
      }

      // Đánh dấu đã kết nối lần đầu
      _isInitialConnection = false;
    } catch (e) {
      emit(state.copyWith(isConnected: false, selectedFiles: state.selectedFiles));
      _showError('Không thể kết nối server. Vui lòng kiểm tra mạng.');
    }
  }

  void messegeChanged(String value) {
    emit(state.copyWith(messege: value, selectedFiles: state.selectedFiles));
  }

  void clearError() {
    _errorTimer?.cancel();
    emit(state.copyWith(error: null, selectedFiles: state.selectedFiles));
  }

  void _showError(String error) {
    _errorTimer?.cancel();
    emit(state.copyWith(error: error, selectedFiles: state.selectedFiles));

    // Tự động clear error state sau khi SnackBar hiển thị
    _errorTimer = Timer(const Duration(milliseconds: 500), () {
      if (!isClosed) {
        emit(state.copyWith(error: null, selectedFiles: state.selectedFiles));
      }
    });
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
              if (fileSize <= 10 * 1024 * 1024) {
                // 10MB limit
                imageFiles.add(file);
              } else {
                // File quá lớn - bỏ qua không thông báo lỗi
              }
            }
          } catch (e) {
            // Bỏ qua ảnh lỗi, không hiển thị error log
          }
        }

        if (imageFiles.isNotEmpty) {
          emit(state.copyWith(
            selectedFiles: [...state.selectedFiles, ...imageFiles],
            isLoading: false,
          ));
        } else {
          // Không thông báo lỗi khi không chọn ảnh hoặc ảnh quá lớn
          emit(state.copyWith(
            isLoading: false,
            selectedFiles: state.selectedFiles,
          ));
        }
      } else {
        emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
      }
    } catch (e) {
      // Bỏ qua lỗi chọn ảnh, không hiển thị thông báo
      emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
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
            // Bỏ qua file lỗi, tiếp tục với file tiếp theo
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
      // Bỏ qua lỗi chọn file, không hiển thị thông báo
      emit(state.copyWith(isLoading: false, selectedFiles: state.selectedFiles));
    }
  }

  void clearSelectedFiles() {
    emit(state.copyWith(selectedFiles: []));
  }

  void removeSelectedFile(File file) {
    final updatedFiles = List<File>.from(state.selectedFiles)..remove(file);
    emit(state.copyWith(selectedFiles: updatedFiles));
  }

  Future<void> onTapSendMessege() async {
    if ((state.messege?.isEmpty ?? true) && state.selectedFiles.isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true, selectedFiles: state.selectedFiles));

      final timestamp = DateTime.now().toIso8601String();
      final userId = getCurrentUserId();
      final userName = getCurrentUserName();
      final threadId = state.idDir;
      final String localIdBase = DateTime.now().millisecondsSinceEpoch.toString();

      // Gửi tin nhắn văn bản nếu có
      if (state.messege != null && state.messege!.isNotEmpty) {
        final localId = 'local_${localIdBase}_text';
        print("localId: $localId");
        final newMessege = MessegeEntities(
          id: localId,
          threadId: threadId,
          userId: userId,
          messege: state.messege!,
          sentAt: timestamp,
          userName: userName,
          deliveryStatus: MessageDeliveryStatus.sending,
          localId: localId,
        );
        // Hiển thị ngay tin nhắn đang gửi trên UI trước khi gửi WS để tránh race condition
        final updatedList = List<MessegeEntities>.from(state.listMessege)..add(newMessege);
        print("updatedList: $updatedList");
        emit(state.copyWith(listMessege: updatedList));

        final messegeJson = {
          ...newMessege.toJson(),
          'type': 'message',
          'dir_id': threadId,
        };

        _webSocketChannel?.sink.add(jsonEncode(messegeJson));
      }

      // Gửi các file tuần tự để tránh quá tải
      for (final file in state.selectedFiles) {
        try {
          if (await file.exists()) {
            final encoded = await _encodeFileToBase64Safe(file.path);
            if (encoded != null) {
              final localId = 'local_${localIdBase}_${path.basename(file.path)}';
              final newMessege = MessegeEntities(
                id: localId,
                threadId: threadId,
                userId: userId,
                messege: '',
                sentAt: timestamp,
                userName: userName,
                fileName: path.basename(file.path),
                fileUrl: file.path,
                fileType: _getFileType(file),
                deliveryStatus: MessageDeliveryStatus.sending,
                localId: localId,
              );
              // Đưa placeholder tin nhắn file lên UI ngay trước khi gửi WS
              final updatedList = List<MessegeEntities>.from(state.listMessege)..add(newMessege);
              emit(state.copyWith(listMessege: updatedList));

              final fileJson = {
                ...newMessege.toJson(),
                'type': 'message',
                'dir_id': threadId,
                'file_data': encoded,
              };

              _webSocketChannel?.sink.add(jsonEncode(fileJson));
            }
          }
        } catch (e) {
          // Bỏ qua file lỗi, tiếp tục với file tiếp theo
        }
      }

      messegeController.clear();
      emit(state.copyWith(
        messege: '',
        selectedFiles: [],
        isLoading: false,
        error: null, // Clear error khi gửi tin nhắn thành công
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
      ));
      _showError('Không thể gửi tin nhắn. Vui lòng thử lại.');
    }
  }

  // Hàm xử lý file an toàn hơn
  Future<String?> _encodeFileToBase64Safe(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null; // File không tồn tại, bỏ qua im lặng
      }

      final fileSize = await file.length();
      // Giới hạn kích thước file (10MB)
      if (fileSize > 10 * 1024 * 1024) {
        return null; // File quá lớn, bỏ qua im lặng
      }

      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null; // Lỗi encode, bỏ qua im lặng
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
    _errorTimer?.cancel();
    await _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    messegeController.dispose();
    return super.close();
  }
}
