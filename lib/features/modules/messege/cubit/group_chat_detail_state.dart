part of 'group_chat_detail_cubit.dart';

class GroupChatDetailState extends Equatable {
  final List<UserEntities> users;
  final List<MessegeEntities> messages;
  final String groupName;
  final bool isLoading;
  final String? error;

  const GroupChatDetailState({
    required this.users,
    required this.messages,
    required this.groupName,
    required this.isLoading,
    this.error,
  });

  GroupChatDetailState copyWith({
    List<UserEntities>? users,
    List<MessegeEntities>? messages,
    String? groupName,
    bool? isLoading,
    String? error,
  }) {
    return GroupChatDetailState(
      users: users ?? this.users,
      messages: messages ?? this.messages,
      groupName: groupName ?? this.groupName,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [users, messages, groupName, isLoading, error];
}
