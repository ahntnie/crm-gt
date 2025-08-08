import 'package:equatable/equatable.dart';

class UserEntities extends Equatable {
  String? id;
  String? name;
  String? phone;
  String? role;
  String? userName;

  UserEntities({
    this.id,
    this.name,
    this.phone,
    this.role,
  });
  @override
  List<Object?> get props => [
        name,
      ];

  factory UserEntities.fromJson(Map<String, dynamic> json) => UserEntities(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        phone: json["phone"]?.toString(),
        role: json["role"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "role": role,
      };
}
