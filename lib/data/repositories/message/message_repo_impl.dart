import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/domains/repositories/message/message_repo.dart';

import '../../../domains/entities/message/message_entities.dart';
import '../../data_source/remote/api_endpoints.dart';
import '../../models/response/base_response.dart';

class MessageRepoImpl extends BaseRepository implements MessageRepo {
  @override
  Future<List<MessageEntities>> getChatThreadByIdDir(String idDir) async {
    List<MessageEntities> listData = [];
    MessageEntities mess = MessageEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getChatThread, {"id_dir": idDir});
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    final dirResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    print(res.data?.data);
    if (dirResponse.data is List) {
      for (var e in dirResponse.data) {
        mess = MessageEntities.fromJson(e);
        // print(mess.toJson());
        listData.add(mess);
      }
    }
    return listData;
  }
}
