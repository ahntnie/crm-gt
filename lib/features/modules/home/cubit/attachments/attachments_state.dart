import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:equatable/equatable.dart';

class AttachmentState extends Equatable {
  final List<AttachmentEntities> listAttachments;
  final bool isLoading;
  final String? error;
  final bool uploadSuccess;
  final String? uploadMessage;
  const AttachmentState({
    this.listAttachments = const [],
    this.isLoading = false,
    this.error,
    this.uploadSuccess = false,
    this.uploadMessage,
  });

  AttachmentState copyWith({
    List<AttachmentEntities>? listAttachments,
    bool? isLoading,
    String? error,
    bool? uploadSuccess,
    String? uploadMessage,
  }) {
    return AttachmentState(
      listAttachments: listAttachments ?? this.listAttachments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      uploadMessage: uploadMessage ?? this.uploadMessage,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
  }

  @override
  List<Object?> get props => [listAttachments, isLoading, error, uploadSuccess, uploadMessage];
}

final class AttachmentsInitial extends AttachmentState {
  const AttachmentsInitial() : super();
}
