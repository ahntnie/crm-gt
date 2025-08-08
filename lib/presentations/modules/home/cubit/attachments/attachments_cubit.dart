import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/data/models/request/attachments/attachment_request.dart';
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:crm_gt/domains/usecases/attachments/attachments_usecase.dart';
import 'package:crm_gt/presentations/modules/home/cubit/attachments/attachments_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  final attachmentUseCase = getIt.get<AttachmentsUsecase>();
  AttachmentCubit() : super(const AttachmentState());

  Future<List<AttachmentEntities>> getListAttachMentsById(String id) async {
    emit(state.copyWith(isLoading: true)); // Bắt đầu loading
    try {
      final listAttachments = await attachmentUseCase.getListAttachMentsById(id);
      emit(state.copyWith(listAttachments: listAttachments, isLoading: false)); // Kết thúc loading
      print('List attachments fetched successfully: ${listAttachments.length}');
      return listAttachments;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<void> uploadAttactments(AttachmentRequest attachmentRequest) async {
    emit(state.copyWith(isLoading: true, uploadSuccess: false, uploadMessage: null));
    try {
      final msg = await attachmentUseCase.uploadAttactments(attachmentRequest);
      emit(state.copyWith(
        isLoading: false,
        uploadSuccess: true,
        uploadMessage: msg,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        uploadSuccess: false,
        error: e.toString(),
        uploadMessage: "Tải lên thất bại",
      ));
    }
  }
}
