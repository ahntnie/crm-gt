import 'package:equatable/equatable.dart';

class MessageEntities extends Equatable {
  String? id;
  String? threadId;
  String? userId;
  String? message;
  String? sentAt;
  String? userName;

  MessageEntities({
    this.id,
    this.threadId,
    this.userId,
    this.message,
    this.sentAt,
    this.userName,
  });
  @override
  List<Object?> get props => [
        threadId,
      ];

  factory MessageEntities.fromJson(Map<String, dynamic> json) => MessageEntities(
        id: json["id"],
        threadId: json["thread_id"],
        userId: json["user_id"],
        message: json["message"],
        sentAt: json["sent_at"],
        userName: json["user_name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "thread_id": threadId,
        "user_id": userId,
        "parent_name": message,
        "sent_at": sentAt,
        "user_name": userName,
      };
}
