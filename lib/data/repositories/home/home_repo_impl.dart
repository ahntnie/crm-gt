import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/repositories/home/home_repo.dart';
import 'package:dio/dio.dart';

import '../../models/response/base_response.dart';

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
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        dir = DirEntities.fromJson(e);
        listDir.add(dir);
      }
    }
    return listDir;
  }

  @override
  Future<List<DirEntities>> getDirByLevel(String level) async {
    List<DirEntities> listDir = [];
    DirEntities dir = DirEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getDirByLevel, {'level': level});
    final res = await Result.guardAsync(() => getDir(
        path: url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        dir = DirEntities.fromJson(e);
        listDir.add(dir);
      }
    }
    return listDir;
  }

  @override
  Future<DirEntities> getDirById(String id) async {
    List<DirEntities> listDir = [];
    DirEntities dir = DirEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getDirById, {'id': id});
    print(url);
    final res = await Result.guardAsync(() => getDir(
        path: url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    dir = DirEntities.fromJson(dirResponse.data);
    return dir;
  }

  @override
  Future<List<DirEntities>> getDirByParentId(String parentId) async {
    List<DirEntities> listDir = [];
    DirEntities dir = DirEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getDirFromProductModel, {});
    final res = await Result.guardAsync(() => getDir(
        path: url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        dir = DirEntities.fromJson(e);
        if (dir.parentId == parentId) {
          listDir.add(dir);
        }
      }
    }
    return listDir;
  }

  @override
  Future<String> invatedToChat(String id, String phone) async {
    const url = ApiEndpoints.invatedToChat;
    final res = await Result.guardAsync(() => post(
        path: url,
        body: {"thread_id": id, "phone": phone},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    final response = jsonDecode(res.data?.data);
    return response['msg'].toString();
  }

  @override
  Future<bool> createDir(String nameDir, String createBy) async {
    const url = ApiEndpoints.createFullDirStructureAPI;
    final res = await Result.guardAsync(() => post(
        path: url,
        body: {"name_dir": nameDir, "created_by": createBy},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    final response = jsonDecode(res.data?.data);
    print('Reeee: ${response.toString()}');
    return int.parse(response['status'].toString()) == 1;
  }
}
