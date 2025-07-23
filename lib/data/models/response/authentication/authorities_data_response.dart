import 'dart:convert';

class AuthoritiesDataResponse {
  final String? accessToken;
  final int? status;
  final int? expired;

  AuthoritiesDataResponse({
    this.accessToken,
    this.status,
    this.expired,
  });

  factory AuthoritiesDataResponse.fromRawJson(String str) =>
      AuthoritiesDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthoritiesDataResponse.fromJson(Map<String, dynamic> json) => AuthoritiesDataResponse(
        accessToken: json["access_token"],
        status: json["status"],
        expired: json["expired"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "status": status,
        "expired": expired,
      };
}
