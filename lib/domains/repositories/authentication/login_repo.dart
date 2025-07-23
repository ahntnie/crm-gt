import 'package:crm_gt/data/models/request/authentication/login_request.dart';
import 'package:crm_gt/domains/entities/authentication/login.dart';

abstract class LoginRepo {
  Future<Login> requestLogin(LoginRequest loginRequest);
}
