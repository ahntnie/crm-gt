import 'package:equatable/equatable.dart';

class MessegeEntities extends Equatable {
  String? id;
  String? threadId;
  String? userId;
  String? messege;
  String? sentAt;
  String? userName;
  String? fileName;
  String? fileUrl;
  String? fileType;

  MessegeEntities({
    this.id,
    this.threadId,
    this.userId,
    this.messege,
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

  factory MessegeEntities.fromJson(Map<String, dynamic> json) => MessegeEntities(
        id: json["id"]?.toString(),
        threadId: json["thread_id"]?.toString(),
        userId: json["user_id"]?.toString(),
        messege: json["message"]?.toString(),
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
        "message": messege,
        "sent_at": sentAt,
        "user_name": userName,
        "file_name": fileName,
        "file_url": fileUrl,
        "file_type": fileType,
      };
}
