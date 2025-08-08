import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/request/profile/change_password_request.dart';
import 'package:crm_gt/data/models/request/profile/change_username_request.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/repositories/authentication/profile_repo.dart';
import 'package:dio/dio.dart';

import '../../models/response/base_response.dart';

class ProfileRepoImpl extends BaseRepository implements ProfileRepo {
  @override
  Future<UserEntities> getCurrentUser() async {
    UserEntities userEntities = UserEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getInfoCustomerFromToken, {});
    print(url);
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    // print('Response: ${res.data}');
    final userResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    // print('User Response: ${userResponse.data}');
    userEntities = UserEntities.fromJson(userResponse.data);
    return userEntities;
  }

  @override
  Future<UserEntities> changeUserName(ChangeUserNameRequest changeUsername) async {
    final url = StringUtils.replacePathParams(ApiEndpoints.changeUserName, {});
    // print('URL: $url');

    final res = await Result.guardAsync(() => post(
          path: url,
          body: changeUsername.toJson(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        ));

    // print('Response: ${res.data}');
    final rawData = res.data?.data;
    if (rawData == null) {
      throw Exception("Không có dữ liệu phản hồi từ server.");
    }
    final Map<String, dynamic> jsonMap = jsonDecode(rawData);
    final int status = jsonMap['status'] ?? -1;
    final String msg = jsonMap['msg'] ?? 'Có lỗi xảy ra';

    if (status == 1) {
      final userEntities = UserEntities.fromJson(jsonMap['data']);
      // print('User Entities: $userEntities');
      return userEntities;
    } else {
      throw Exception(msg);
    }
  }

  @override
  Future<UserEntities> changePassWord(ChangePasswordRequest changePasswordRequest) async {
    final url = StringUtils.replacePathParams(ApiEndpoints.changePassWord, {});
    // print('URL: $url');

    final res = await Result.guardAsync(() => post(
          path: url,
          body: changePasswordRequest.toJson(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        ));

    // print('Response: ${res.data}');
    final rawData = res.data?.data;
    if (rawData == null) {
      throw Exception("Không có dữ liệu phản hồi từ server.");
    }
    final Map<String, dynamic> jsonMap = jsonDecode(rawData);
    final int status = jsonMap['status'] ?? -1;
    final String msg = jsonMap['msg'] ?? 'Có lỗi xảy ra';
    if (status == 1) {
      final userEntities = UserEntities.fromJson(jsonMap['data']);
      // print('User Entities: $userEntities');
      return userEntities;
    } else {
      throw Exception(msg);
    }
  }
}
