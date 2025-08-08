import 'package:crm_gt/data/models/request/authentication/logout_request.dart';
import 'package:crm_gt/domains/entities/authentication/logout.dart';

abstract class LogoutRepo {
  Future<Logout> requestLogout(LogoutRequest logoutRequest);
}
