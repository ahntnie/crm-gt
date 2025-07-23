class LoginDataResponse {
  String? accessToken;
  String? expired;

  LoginDataResponse({
    this.accessToken,
    this.expired,
  });

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) => LoginDataResponse(
        accessToken: json["access_token"],
        expired: json["expired"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expired": expired,
      };

  LoginDataResponse copyWith({
    String? accessToken,
    String? expired,
  }) {
    return LoginDataResponse(
      accessToken: accessToken ?? this.accessToken,
      expired: expired ?? this.expired,
    );
  }
}
