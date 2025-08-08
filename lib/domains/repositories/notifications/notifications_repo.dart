import 'package:crm_gt/domains/entities/notifications/notifications_entities.dart';

abstract class NotificationsRepo {
  Future<NotificationsEntities> getUnreadNotification(String id);
}
