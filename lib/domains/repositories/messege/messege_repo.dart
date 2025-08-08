import 'package:crm_gt/domains/entities/user/user_entities.dart';

import '../../entities/messege/messege_entities.dart';

abstract class MessegeRepo {
  Future<List<MessegeEntities>> getChatThreadByIdDir(String idDir);
  Future<List<UserEntities>> getUserFromChatThread(String idDir);
}
