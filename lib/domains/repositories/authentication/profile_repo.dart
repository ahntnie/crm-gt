import 'package:crm_gt/data/models/request/profile/change_password_request.dart';
import 'package:crm_gt/data/models/request/profile/change_username_request.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';

abstract class ProfileRepo {
  Future<UserEntities> getCurrentUser();
  Future<UserEntities> changeUserName(ChangeUserNameRequest changeUsername);
  Future<UserEntities> changePassWord(ChangePasswordRequest changePasswordRequest);
}
