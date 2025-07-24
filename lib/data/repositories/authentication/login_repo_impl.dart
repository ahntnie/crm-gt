import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/data/models/request/authentication/login_request.dart';
import 'package:crm_gt/data/models/response/authentication/login_data_response.dart';
import 'package:crm_gt/domains/entities/authentication/login.dart';
import 'package:crm_gt/domains/repositories/authentication/login_repo.dart';
import 'package:dio/dio.dart';

class LoginRepoImpl extends BaseRepository implements LoginRepo {
  @override
  Future<Login> requestLogin(LoginRequest loginRequest) async {
    Login login = const Login(data: null);
    final url = StringUtils.replacePathParams(ApiEndpoints.login, {});
    final res = await Result.guardAsync(() => postLogin(
        path: url,
        body: loginRequest.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        )));
    print('hahaha: ${res.data?.data}');
    final loginResponse = jsonDecode(res.data?.data);
    if (loginResponse['status'] == 1) {
      login = Login(
          data: LoginDataResponse(
        accessToken: loginResponse['access_token'],
        info: loginResponse['info'],
      ));
    } else {
      login = const Login(data: null);
    }
    return login;
  }

  @override
  Future<bool> checkTokenLogin() async {
    bool check = false;
    final url = StringUtils.replacePathParams(ApiEndpoints.getInfoCustomerFromToken, {});
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    final loginResponse = jsonDecode(res.data?.data);
    if (loginResponse["status"] == 1) {
      check = true;
    }
    return check;
  }
}
