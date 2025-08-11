import 'package:crm_gt/domains/entities/messege/messege_entities.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_chat_detail_state.dart';

class GroupChatDetailCubit extends Cubit<GroupChatDetailState> {
  GroupChatDetailCubit({
    required List<UserEntities> users,
    required List<MessegeEntities> messages,
    required String groupName,
  }) : super(GroupChatDetailState(
          users: users,
          messages: messages,
          groupName: groupName,
          isLoading: false,
          error: null,
        ));

  void toggleNotification() {
    // TODO: Implement notification toggle logic
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false));
    });
  }

  List<MessegeEntities> getSortedImages() {
    final images = state.messages
        .where((m) =>
            m.fileUrl != null &&
            m.fileUrl!.isNotEmpty &&
            m.fileType != null &&
            m.fileType!.contains('image'))
        .toList()
      ..sort((a, b) {
        final dateA = a.sentAt != null ? DateTime.tryParse(a.sentAt!) : null;
        final dateB = b.sentAt != null ? DateTime.tryParse(b.sentAt!) : null;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA); // Mới nhất lên trước
      });
    return images;
  }

  List<MessegeEntities> getSortedFiles() {
    final files = state.messages
        .where((m) =>
            m.fileUrl != null &&
            m.fileUrl!.isNotEmpty &&
            m.fileType != null &&
            !m.fileType!.contains('image'))
        .toList()
      ..sort((a, b) {
        final dateA = a.sentAt != null ? DateTime.tryParse(a.sentAt!) : null;
        final dateB = b.sentAt != null ? DateTime.tryParse(b.sentAt!) : null;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA); // Mới nhất lên trước
      });
    return files;
  }

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
