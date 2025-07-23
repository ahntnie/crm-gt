import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/response/dir/dir_data_response.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/repositories/home/home_repo.dart';
import 'package:dio/dio.dart';

class HomeRepoImpl extends BaseRepository implements HomeRepo {
  @override
  Future<List<DirEntities>> getAllDir() async {
    List<DirEntities> listDir = [];
    DirEntities dir = DirEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getDirFromProductModel, {});
    final res = await Result.guardAsync(() => getDir(
        path: url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    print('hahaheeh: ${res.data?.data}');
    final dirResponse = DirDataResponse.fromJson(jsonDecode(res.data?.data));
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        dir = DirEntities.fromJson(e);
        listDir.add(dir);
      }
    }
    print('Dir nè: ${listDir.first.name}');
    return listDir;
  }
}
