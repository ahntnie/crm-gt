import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/data_source/remote/api_endpoints.dart';
import 'package:crm_gt/data/data_source/remote/base_repository.dart';
import 'package:crm_gt/domains/entities/notifications/notifications_entities.dart';
import 'package:crm_gt/domains/repositories/notifications/notifications_repo.dart';

import '../../models/response/base_response.dart';

class NotificationsRepoIml extends BaseRepository implements NotificationsRepo {
  @override
  Future<NotificationsEntities> getUnreadNotification(String id) async {
    NotificationsEntities notifications = NotificationsEntities();
    final url = StringUtils.replacePathParams(ApiEndpoints.getUnreadNotification, {'id': id});
    // print(url);
    final res = await Result.guardAsync(() => get(
          path: url,
        ));
    // print('Response: ${res.data}');
    final notiResponse = BaseDataResponse.fromJson(jsonDecode(res.data?.data));
    // print('notifications: ${notiResponse.data}');
    notifications = NotificationsEntities.fromJson(notiResponse.data);
    return notifications;
  }
}
