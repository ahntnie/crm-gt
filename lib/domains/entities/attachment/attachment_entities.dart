import 'package:equatable/equatable.dart';

class AttachmentEntities extends Equatable {
  String? id;
  String? fileName;
  String? fileUrl;
  String? fileType;
  String? uploadedAt;
  AttachmentEntities({
    this.id,
    this.uploadedAt,
    this.fileName,
    this.fileUrl,
    this.fileType,
  });
  @override
  List<Object?> get props => [
        id,
      ];

  factory AttachmentEntities.fromJson(Map<String, dynamic> json) => AttachmentEntities(
        id: json["id"]?.toString(),
        uploadedAt: json["uploaded_at"]?.toString(),
        fileName: json["file_name"]?.toString(),
        fileUrl: json["file_url"]?.toString(),
        fileType: json["file_type"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "uploaded_at": uploadedAt,
        "file_name": fileName,
        "file_url": fileUrl,
        "file_type": fileType,
      };
}
