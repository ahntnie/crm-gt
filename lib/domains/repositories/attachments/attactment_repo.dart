import 'package:crm_gt/data/models/request/attachments/attachment_request.dart';
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';

abstract class AttachmentRepo {
  Future<List<AttachmentEntities>> getListAttachMentsById(String id);
  Future<String> uploadAttactments(AttachmentRequest attachmentRequest);
}
