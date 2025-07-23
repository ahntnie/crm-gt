class LoginRequest {
  String password;
  String phone;
  String fcmToken;

  LoginRequest({
    required this.phone,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "fcm_token": fcmToken,
        "phone": phone,
        "password": password,
      };
}
