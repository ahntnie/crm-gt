part of 'message_cubit.dart';

class MessageState extends Equatable {
  final List<MessageEntities> listMessage;
  final String? idDir;
  final String? message;
  final bool isLoading;
  final String? error;
  final bool isConnected; // Thêm trạng thái kết nối

  const MessageState({
    this.listMessage = const [],
    this.idDir,
    this.message,
    this.isLoading = false,
    this.error,
    this.isConnected = false, // Mặc định là chưa kết nối
  });

  @override
  List<Object?> get props => [listMessage, idDir, message, isLoading, error, isConnected];

  MessageState copyWith({
    List<MessageEntities>? listMessage,
    String? idDir,
    String? message,
    bool? isLoading,
    String? error,
    bool? isConnected,
  }) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      idDir: idDir ?? this.idDir,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

final class MessageInitial extends MessageState {}
