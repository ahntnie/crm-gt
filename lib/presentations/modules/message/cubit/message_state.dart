part of 'message_cubit.dart';

class MessageState extends Equatable {
  final List<MessageEntities> listMessage;
  final String? idDir;
  
  const MessageState({
    this.listMessage = const [],
    this.idDir,
  });
  @override
  List<Object?> get props => [listMessage];

  MessageState copyWith({List<MessageEntities>? listMessage, String? idDir}) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      idDir: idDir ?? this.idDir,
    );
  }
}

final class MessageInitial extends MessageState {}
