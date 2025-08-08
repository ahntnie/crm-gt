import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/repositories/messege/messege_repo.dart';

import '../../entities/messege/messege_entities.dart';

class MessegeUseCase {
  final MessegeRepo _repo;
  MessegeUseCase(this._repo);

  Future<List<MessegeEntities>> getChatThreadByIdDir(String idDir) async {
    return await _repo.getChatThreadByIdDir(idDir);
  }

  Future<List<UserEntities>> getUserFromChatThread(String idDir) async {
    return await _repo.getUserFromChatThread(idDir);
  }
}
