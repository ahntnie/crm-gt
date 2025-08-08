import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/repositories/messege/messege_repo.dart';

import '../../../domains/entities/messege/messege_entities.dart';
import '../../data_source/remote/api_endpoints.dart';
import '../../models/response/base_response.dart';

class MessegeRepoImpl extends BaseRepository implements MessegeRepo {
  @override
  Future<List<MessegeEntities>> getChatThreadByIdDir(String idDir) async {
    List<MessegeEntities> listData = [];
    MessegeEntities mess = MessegeEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getChatThread, {"id_dir": idDir});
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    // print(res.data?.data);
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        mess = MessegeEntities.fromJson(e);
        // print(mess.toJson());
        listData.add(mess);
      }
    }
    return listData;
  }

  @override
  Future<List<UserEntities>> getUserFromChatThread(String idDir) async {
    List<UserEntities> listUsers = [];
    UserEntities user = UserEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getUserFromChatThread, {"id": idDir});
    print('url $url');
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    print('Ressponse ${res.data?.data}');
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        user = UserEntities.fromJson(e);
        listUsers.add(user);
      }
    }
    return listUsers;
  }
}
