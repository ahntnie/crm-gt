import 'package:equatable/equatable.dart';

enum MessageDeliveryStatus { sending, sent, failed }

class MessegeEntities extends Equatable {
  final String? id;
  final String? threadId;
  final String? userId;
  final String? messege;
  final String? sentAt;
  final String? userName;
  final String? fileName;
  final String? fileUrl;
  final String? fileType;
  // Client-only fields (not serialized)
  final MessageDeliveryStatus? deliveryStatus;
  final String? localId;

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
    this.deliveryStatus,
    this.localId,
  });
  @override
  List<Object?> get props => [
        id,
        threadId,
        userId,
        messege,
        sentAt,
        userName,
        fileName,
        fileUrl,
        fileType,
        deliveryStatus,
        localId,
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
        localId: json["local_id"]?.toString(),
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
        // Do not send deliveryStatus to server, but include local_id for client reconciliation if present
        if (localId != null) "local_id": localId,
      };
}
