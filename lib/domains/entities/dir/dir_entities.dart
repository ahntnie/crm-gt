import 'package:equatable/equatable.dart';

class DirEntities extends Equatable {
  String? id;
  String? name;
  String? parentId;
  String? parentName;
  String? type;
  String? level;
  String? createdBy;
  String? createdAt;

  DirEntities({
    this.id,
    this.name,
    this.parentId,
    this.parentName,
    this.type,
    this.level,
    this.createdBy,
    this.createdAt,
  });
  @override
  List<Object?> get props => [
        name,
      ];

  factory DirEntities.fromJson(Map<String, dynamic> json) => DirEntities(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        parentId: json["parent_id"],
        parentName: json["parent_name"],
        type: json["type"],
        level: json["level"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "created_at": createdAt,
        "parent_id": parentId,
        "parent_name": parentName,
        "type": type,
        "level": level,
      };
}
