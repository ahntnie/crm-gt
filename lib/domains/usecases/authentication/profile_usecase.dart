import 'package:crm_gt/data/models/request/profile/change_password_request.dart';
import 'package:crm_gt/data/models/request/profile/change_username_request.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/repositories/authentication/profile_repo.dart';

class ProfileUsecase {
  final ProfileRepo _repo;
  ProfileUsecase(this._repo);

  Future<UserEntities> getCurrentUser() async {
    return await _repo.getCurrentUser();
  }

  Future<UserEntities> changeUserName(ChangeUserNameRequest changeUsername) async {
    return await _repo.changeUserName(changeUsername);
  }

  Future<UserEntities> changePassWord(ChangePasswordRequest changePasswordRequest) async {
    return await _repo.changePassWord(changePasswordRequest);
  }
}
