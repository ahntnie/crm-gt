import 'package:crm_gt/domains/repositories/message/message_repo.dart';

import '../../entities/message/message_entities.dart';

class MessageUseCase {
  final MessageRepo _repo;
  MessageUseCase(this._repo);

  Future<List<MessageEntities>> getChatThreadByIdDir(String idDir) async {
    return await _repo.getChatThreadByIdDir(idDir);
  }
}
