class LogoutRequest {
  String fcmToken;

  LogoutRequest({
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "fcm_token": fcmToken,
      };
}
