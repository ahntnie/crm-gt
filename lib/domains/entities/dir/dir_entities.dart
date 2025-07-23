import 'package:equatable/equatable.dart';

class DirEntities extends Equatable {
  String? id;
  String? name;
  String? createdBy;
  String? createdAt;

  DirEntities({
    this.id,
    this.name,
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
      );
}
