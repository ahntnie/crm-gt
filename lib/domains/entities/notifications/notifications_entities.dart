import 'package:equatable/equatable.dart';

class NotificationsEntities extends Equatable {
  final String? dirType;
  final String? threadId;
  final String? parentDirId; // Thêm để lưu parent_dir_id từ WebSocket
  final int? unreadCount;

  NotificationsEntities({
    this.dirType,
    this.threadId,
    this.parentDirId,
    this.unreadCount,
  });

  @override
  List<Object?> get props => [dirType, threadId, parentDirId, unreadCount];

  factory NotificationsEntities.fromJson(Map<String, dynamic> json) => NotificationsEntities(
        dirType: json["dir_type"],
        threadId: json["thread_id"],
        parentDirId: json["parent_dir_id"],
        unreadCount: json["unread_count"],
      );

  Map<String, dynamic> toJson() => {
        "dir_type": dirType,
        "thread_id": threadId,
        "parent_dir_id": parentDirId,
        "unread_count": unreadCount,
      };
}
