import 'package:crm_gt/data/models/request/attachments/attachment_request.dart';
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:crm_gt/domains/repositories/attachments/attactment_repo.dart';

class AttachmentsUsecase {
  final AttachmentRepo _repo;
  AttachmentsUsecase(this._repo);
  Future<List<AttachmentEntities>> getListAttachMentsById(String id) async {
    return await _repo.getListAttachMentsById(id);
  }

  Future<String> uploadAttactments(AttachmentRequest attachmentRequest) async {
    return await _repo.uploadAttactments(attachmentRequest);
  }
}
