import 'package:crm_gt/data/models/request/authentication/login_request.dart';
import 'package:crm_gt/domains/entities/authentication/login.dart';
import 'package:crm_gt/domains/repositories/authentication/login_repo.dart';

class LoginUsecase {
  final LoginRepo _repo;
  LoginUsecase(this._repo);

  Future<Login> requestLogin(LoginRequest loginRequest) async {
    return await _repo.requestLogin(loginRequest);
  }

  Future<bool> checkTokenLogin() async {
    return await _repo.checkTokenLogin();
  }
}
