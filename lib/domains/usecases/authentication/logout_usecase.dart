import 'package:crm_gt/data/models/request/authentication/logout_request.dart';
import 'package:crm_gt/domains/entities/authentication/logout.dart';
import 'package:crm_gt/domains/repositories/authentication/logout_repo.dart';

class LogoutUsecase {
  final LogoutRepo _repo;
  LogoutUsecase(this._repo);

  Future<Logout> requestLogout(LogoutRequest logoutRequest) async {
    return await _repo.requestLogout(logoutRequest);
  }
}
