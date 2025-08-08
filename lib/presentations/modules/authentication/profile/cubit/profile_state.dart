import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final UserEntities? userInfo;
  final String? phone;
  final String name;
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;
  final String? successMessage;
  final String password;

  // Change Password fields
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isChangePasswordLoading;
  final bool isFormValid;

  const ProfileState({
    this.userInfo,
    this.phone,
    this.name = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.successMessage,
    this.password = '',
    // Change Password defaults
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isCurrentPasswordVisible = false,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isChangePasswordLoading = false,
    this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        userInfo,
        phone,
        name,
        isLoading,
        isPasswordVisible,
        errorMessage,
        successMessage,
        password,
        currentPassword,
        newPassword,
        confirmPassword,
        isCurrentPasswordVisible,
        isNewPasswordVisible,
        isConfirmPasswordVisible,
        isChangePasswordLoading,
        isFormValid,
      ];

  ProfileState copyWith({
    UserEntities? userInfo,
    String? phone,
    String? name,
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    String? password,
    String? successMessage,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isChangePasswordLoading,
    bool? isFormValid,
  }) {
    return ProfileState(
      userInfo: userInfo ?? this.userInfo,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
      successMessage: successMessage,
      password: password ?? this.password,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isCurrentPasswordVisible: isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isChangePasswordLoading: isChangePasswordLoading ?? this.isChangePasswordLoading,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial() : super();
}
