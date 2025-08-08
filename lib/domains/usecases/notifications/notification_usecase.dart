import 'package:crm_gt/domains/entities/notifications/notifications_entities.dart';
import 'package:crm_gt/domains/repositories/notifications/notifications_repo.dart';

class NotificationsUsecase {
  final NotificationsRepo _repo;
  NotificationsUsecase(this._repo);

  Future<NotificationsEntities> getUnreadNotification(String id) async {
    return await _repo.getUnreadNotification(id);
  }
}
