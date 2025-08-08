class LoginDataResponse {
  String? accessToken;
  String? msg;
  String? expired;
  dynamic info;
  LoginDataResponse({this.accessToken, this.expired, this.info, this.msg});

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) => LoginDataResponse(
        accessToken: json["access_token"],
        expired: json["expired"],
        info: json["info"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expired": expired,
        "info": info,
        "msg": msg,
      };

  LoginDataResponse copyWith({
    String? accessToken,
    String? expired,
    dynamic info,
    String? msg,
  }) {
    return LoginDataResponse(
      accessToken: accessToken ?? this.accessToken,
      expired: expired ?? this.expired,
      info: info ?? this.info,
      msg: msg ?? this.msg,
    );
  }
}
