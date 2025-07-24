import '../../entities/message/message_entities.dart';

abstract class MessageRepo {
  Future<List<MessageEntities>> getChatThreadByIdDir(String idDir);
}
