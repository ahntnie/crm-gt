import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? expectedCompletionDate;
  final String? completionPercentage; // 0.0 to 100.0
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? dirId;
  final String? createdByName;
  final String? dirName;

  const ProgressEntity({
    this.id,
    this.title,
    this.description,
    this.expectedCompletionDate,
    this.completionPercentage,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.dirId,
    this.createdByName,
    this.dirName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        expectedCompletionDate,
        completionPercentage,
        createdBy,
        createdAt,
        updatedAt,
        dirId,
        createdByName,
        dirName,
      ];

  factory ProgressEntity.fromJson(Map<String, dynamic> json) => ProgressEntity(
        id: json["id"]?.toString(),
        title: json["title"]?.toString(),
        description: json["description"]?.toString(),
        expectedCompletionDate: json["expected_completion_date"],
        completionPercentage: json["completion_percentage"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        dirId: json["dir_id"]?.toString(),
        createdByName: json["created_by_name"],
        dirName: json["dir_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "expected_completion_date": expectedCompletionDate,
        "completion_percentage": completionPercentage,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "dir_id": dirId,
        "created_by_name": createdByName,
        "dir_name": dirName,
      };
}
