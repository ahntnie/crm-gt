class LoginDataResponse {
  String? accessToken;
  String? expired;
  dynamic info;
  LoginDataResponse({this.accessToken, this.expired, this.info});

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) => LoginDataResponse(
        accessToken: json["access_token"],
        expired: json["expired"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expired": expired,
        "info": info,
      };

  LoginDataResponse copyWith({
    String? accessToken,
    String? expired,
    dynamic info,
  }) {
    return LoginDataResponse(
      accessToken: accessToken ?? this.accessToken,
      expired: expired ?? this.expired,
      info: info ?? this.info,
    );
  }
}
