class ChangePasswordRequest {
  String currentPassword;
  String newPassword;
  String confirmPassword;
  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };
}
