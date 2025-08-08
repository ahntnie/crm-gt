import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/request/attachments/attachment_request.dart';
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:crm_gt/domains/repositories/attachments/attactment_repo.dart';
import 'package:dio/dio.dart';

import '../../models/response/base_response.dart';

class AttachMentRepoImpl extends BaseRepository implements AttachmentRepo {
  @override
  Future<List<AttachmentEntities>> getListAttachMentsById(String id) async {
    List<AttachmentEntities> listAttachment = [];
    AttachmentEntities attachmentEntities = AttachmentEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getAttachmentByDirId, {'id': id});
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    final attachmentReponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    // print(attachmentReponse.data);
    // print('Attachment Response: ${attachmentReponse.data}');
    if (attachmentReponse.data is List) {
      for (var e in attachmentReponse.data) {
        attachmentEntities = AttachmentEntities.fromJson(e);
        listAttachment.add(attachmentEntities);
      }
    }
    return listAttachment;
  }

  @override
  Future<String> uploadAttactments(AttachmentRequest attachmentRequest) async {
    print('==> uploadAttactments CALLED');
    final url = StringUtils.replacePathParams(ApiEndpoints.uploadAttachment, {});
    print('==> url: $url');

    final formData = FormData();
    formData.fields.add(MapEntry('thread_id', attachmentRequest.threadId));
    for (int i = 0; i < attachmentRequest.files.length; i++) {
      final filePath = attachmentRequest.files[i];
      formData.files.add(MapEntry(
        'files[]',
        await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      ));
    }

    final res = await Result.guardAsync(() => post(
          path: url,
          body: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        ));
    final response = jsonDecode(res.data?.data);
    print('Attachment Response:  [${response.toString()}');
    return response['msg'].toString();
  }
}
