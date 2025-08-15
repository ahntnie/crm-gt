import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/request/progress/create_progress_request.dart';
import 'package:crm_gt/data/models/request/progress/update_progress_request.dart';
import 'package:crm_gt/data/models/response/base_response.dart';
import 'package:crm_gt/domains/entities/progress/progress_entities.dart';
import 'package:crm_gt/domains/repositories/progress/progress_repo.dart';
import 'package:dio/dio.dart';

class ProgressRepoImpl extends BaseRepository implements ProgressRepo {
  @override
  Future<String> createProgress(CreateProgressRequest request) async {
    final url = StringUtils.replacePathParams(ApiEndpoints.createProgress, {});
    final res = await Result.guardAsync(() => post(
        path: url,
        body: request.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));

    final response = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    if (response.status == 1) {
      return response.msg ?? '';
    } else {
      throw Exception(response.msg ?? 'Failed to create progress');
    }
  }

  @override
  Future<bool> updateProgress(UpdateProgressRequest request) async {
    final url = StringUtils.replacePathParams(ApiEndpoints.updateProgress, {});
    final res = await Result.guardAsync(() => post(
        path: url,
        body: request.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));

    final response = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    return response.status == 1;
  }

  @override
  Future<ProgressEntity> getProgressById(String id) async {
    final url = StringUtils.replacePathParams(ApiEndpoints.getProgressById, {'id': id});
    final res = await Result.guardAsync(() => get(path: url));

    print('Raw response data: ${res.data?.data}');
    final response = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    print('Parsed response: status=${response.status}, data=${response.data}');
    if (response.status == 1 && response.data != null) {
      return ProgressEntity.fromJson(response.data);
    } else {
      throw Exception(response.msg ?? 'Failed to get progress');
    }
  }

  @override
  Future<List<ProgressEntity>> getProgressByDirId(String dirId) async {
    print('dirId: $dirId');
    print('ApiEndpoints.getProgressByDirId: ${ApiEndpoints.getProgressByDirId}');
    print('Vào hàm');
    List<ProgressEntity> progressList = [];
    ProgressEntity progress = ProgressEntity();
    final url = StringUtils.replacePathParams(ApiEndpoints.getProgressByDirId, {'id': dirId});
    final res = await Result.guardAsync(() => get(path: url));
    print('Raw response data: ${res.data?.data}');
    final response = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    print('Parsed response: status=${response.status}, data=${response.data}');

    if (response.status == 1 && response.data != null) {
      if (response.data is List) {
        for (var e in response.data) {
          if (e != null) {
            progress = ProgressEntity.fromJson(e);
            progressList.add(progress);
          }
        }
      }
    } else {
      throw Exception(response.msg ?? 'Failed to get progress list');
    }

    return progressList;
  }
}
