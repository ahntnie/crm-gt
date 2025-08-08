class ChangeUserNameRequest {
  String password;
  String newUsername;

  ChangeUserNameRequest({
    required this.newUsername,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "new_username": newUsername,
        "password": password,
      };
}
