import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/models/request/profile/change_password_request.dart';
import 'package:crm_gt/data/models/request/profile/change_username_request.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/domains/usecases/authentication/profile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final profileUseCase = getIt.get<ProfileUsecase>();
  ProfileCubit() : super(const ProfileInitial());
  late final usernameController = TextEditingController();
  late final passwordController = TextEditingController();
  late final currentPasswordController = TextEditingController();
  late final newPasswordController = TextEditingController();
  late final confirmPasswordController = TextEditingController();

  Future<void> getCurrentUser() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));
    try {
      UserEntities currentUser = await profileUseCase.getCurrentUser();
      await AppSP.set('user_info', jsonEncode(currentUser.toJson()));
      if (!isClosed) {
        emit(state.copyWith(
          userInfo: currentUser,
          name: currentUser.name ?? '',
          phone: currentUser.phone,
          isLoading: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi khi lấy thông tin người dùng: ${e.toString()}',
        ));
      }
    }
  }

  void usernameChanged(String value) {
    if (!isClosed) {
      emit(state.copyWith(name: value, errorMessage: null));
    }
  }

  void passwordChanged(String value) {
    if (!isClosed) {
      emit(state.copyWith(password: value, errorMessage: null));
    }
  }

  void currentPasswordChanged(String value) {
    if (!isClosed) {
      emit(state.copyWith(
        currentPassword: value,
        errorMessage: null,
        isFormValid: _validatePasswordForm(value, state.newPassword, state.confirmPassword),
      ));
    }
  }

  void newPasswordChanged(String value) {
    if (!isClosed) {
      emit(state.copyWith(
        newPassword: value,
        errorMessage: null,
        isFormValid: _validatePasswordForm(state.currentPassword, value, state.confirmPassword),
      ));
    }
  }

  void confirmPasswordChanged(String value) {
    if (!isClosed) {
      emit(state.copyWith(
        confirmPassword: value,
        errorMessage: null,
        isFormValid: _validatePasswordForm(state.currentPassword, state.newPassword, value),
      ));
    }
  }

  bool _validatePasswordForm(String currentPassword, String newPassword, String confirmPassword) {
    return !Utils.isNullOrEmpty(currentPassword) &&
        !Utils.isNullOrEmpty(newPassword) &&
        !Utils.isNullOrEmpty(confirmPassword) &&
        ValidateUtils.validateConfirmPass(newPassword, confirmPassword) &&
        ValidateUtils.validatePassword(newPassword) &&
        newPassword != currentPassword; // Đảm bảo mật khẩu mới khác mật khẩu hiện tại
  }

  Future<void> changeUsername() async {
    if (isClosed) return;
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final currentUser = state.userInfo;
      if (currentUser == null) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Không tìm thấy người dùng hiện tại.',
          ));
        }
        return;
      }

      final request = ChangeUserNameRequest(
        newUsername: state.name,
        password: state.password,
      );

      final updatedUser = await profileUseCase.changeUserName(request);
      await AppSP.set('user_info', jsonEncode(updatedUser.toJson()));

      if (!isClosed) {
        emit(state.copyWith(
          userInfo: updatedUser,
          name: updatedUser.name ?? '',
          phone: updatedUser.phone,
          isLoading: false,
          successMessage: 'Cập nhật tên thành công',
        ));
        usernameController.clear();
        passwordController.clear();
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
    Utils.dismissKeyboard();
  }

  Future<void> changePassword() async {
    if (isClosed) return;
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage:
            'Vui lòng kiểm tra lại mật khẩu. Mật khẩu mới và xác nhận phải khớp, dài ít nhất 6 ký tự và khác mật khẩu hiện tại.',
      ));
      return;
    }

    emit(state.copyWith(
      isChangePasswordLoading: true,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final request = ChangePasswordRequest(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
      );

      final updatedUser = await profileUseCase.changePassWord(request);
      await AppSP.set('user_info', jsonEncode(updatedUser.toJson()));

      if (!isClosed) {
        emit(state.copyWith(
          userInfo: updatedUser,
          isChangePasswordLoading: false,
          successMessage: 'Đổi mật khẩu thành công!!!',
          currentPassword: '',
          newPassword: '',
          confirmPassword: '',
          isFormValid: false,
        ));
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      // Xử lý các thông báo lỗi cụ thể từ API
      if (errorMessage.contains('Mật khẩu hiện tại không chính xác')) {
        errorMessage = 'Mật khẩu hiện tại không chính xác';
      } else if (errorMessage.contains('Mật khẩu mới phải khác mật khẩu hiện tại')) {
        errorMessage = 'Mật khẩu mới phải khác mật khẩu hiện tại';
      } else if (errorMessage.contains('Lỗi khi cập nhật mật khẩu')) {
        errorMessage = 'Lỗi khi cập nhật mật khẩu';
      } else {
        errorMessage = 'Có lỗi xảy ra khi đổi mật khẩu';
      }

      if (!isClosed) {
        emit(state.copyWith(
          isChangePasswordLoading: false,
          errorMessage: errorMessage,
        ));
      }
    }
    Utils.dismissKeyboard();
  }

  void togglePasswordVisibility() {
    if (!isClosed) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    }
  }

  void toggleCurrentPasswordVisibility() {
    if (!isClosed) {
      emit(state.copyWith(isCurrentPasswordVisible: !state.isCurrentPasswordVisible));
    }
  }

  void toggleNewPasswordVisibility() {
    if (!isClosed) {
      emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
    }
  }

  void toggleConfirmPasswordVisibility() {
    if (!isClosed) {
      emit(state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
    }
  }

  @override
  void onChange(Change<ProfileState> change) {
    super.onChange(change);
    if (!isClosed) {
      usernameController.text = change.nextState.name;
      passwordController.text = change.nextState.password;
      currentPasswordController.text = change.nextState.currentPassword;
      newPasswordController.text = change.nextState.newPassword;
      confirmPasswordController.text = change.nextState.confirmPassword;
    }
  }
}
