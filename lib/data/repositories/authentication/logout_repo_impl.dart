import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/request/authentication/logout_request.dart';
import 'package:crm_gt/data/models/response/authentication/Logout_data_response.dart';
import 'package:crm_gt/domains/entities/authentication/logout.dart';
import 'package:crm_gt/domains/repositories/authentication/logout_repo.dart';
import 'package:dio/dio.dart';

class LogoutRepoImpl extends BaseRepository implements LogoutRepo {
  @override
  Future<Logout> requestLogout(LogoutRequest logoutRequest) async {
    print('vào hàm requestLogout');
    Logout logout = const Logout(data: null);
    final url = StringUtils.replacePathParams(ApiEndpoints.logout, {});
    final res = await Result.guardAsync(() => post(
        path: url,
        body: logoutRequest.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    print('hahaha: ${res.data?.data}');
    final logoutResponse = jsonDecode(res.data?.data);
    if (logoutResponse['status'] == 1) {
      logout = Logout(
          data: LogoutDataResponse(
        msg: logoutResponse['msg'],
        status: logoutResponse['status'],
      ));
    } else {
      logout = const Logout(data: null);
    }
    return logout;
  }
}
