import 'package:equatable/equatable.dart';

class MessageEntities extends Equatable {
  String? id;
  String? threadId;
  String? userId;
  String? message;
  String? sentAt;
  String? userName;
  String? fileName;
  String? fileUrl;
  String? fileType;

  MessageEntities({
    this.id,
    this.threadId,
    this.userId,
    this.message,
    this.sentAt,
    this.userName,
    this.fileName,
    this.fileUrl,
    this.fileType,
  });
  @override
  List<Object?> get props => [
        threadId,
      ];

  factory MessageEntities.fromJson(Map<String, dynamic> json) => MessageEntities(
        id: json["id"]?.toString(),
        threadId: json["thread_id"]?.toString(),
        userId: json["user_id"]?.toString(),
        message: json["message"]?.toString(),
        sentAt: json["sent_at"]?.toString(),
        userName: json["user_name"]?.toString(),
        fileName: json["file_name"]?.toString(),
        fileUrl: json["file_url"]?.toString(),
        fileType: json["file_type"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "thread_id": threadId,
        "user_id": userId,
        "message": message,
        "sent_at": sentAt,
        "user_name": userName,
        "file_name": fileName,
        "file_url": fileUrl,
        "file_type": fileType,
      };
}
