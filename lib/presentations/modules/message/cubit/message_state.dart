part of 'message_cubit.dart';

class MessageState extends Equatable {
  final List<MessageEntities> listMessage;
  final String? idDir;
  final String? message;
  final bool isLoading;
  final String? error;
  final bool isConnected;
  final List<File> selectedFiles; // Thay đổi từ selectedFile thành selectedFiles

  const MessageState({
    this.listMessage = const [],
    this.idDir,
    this.message,
    this.isLoading = false,
    this.error,
    this.isConnected = false,
    this.selectedFiles = const [], // Mặc định là danh sách rỗng
  });

  @override
  List<Object?> get props =>
      [listMessage, idDir, message, isLoading, error, isConnected, selectedFiles];

  MessageState copyWith({
    List<MessageEntities>? listMessage,
    String? idDir,
    String? message,
    bool? isLoading,
    String? error,
    bool? isConnected,
    List<File>? selectedFiles,
  }) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      idDir: idDir ?? this.idDir,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }
}

final class MessageInitial extends MessageState {}
