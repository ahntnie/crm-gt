import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/data/models/request/authentication/login_request.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final loginUseCase = getIt.get<LoginUsecase>();
  late final usernameController = TextEditingController(text: state.username);
  late final passwordController = TextEditingController(text: state.password);

  LoginCubit() : super(LoginInitial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, error: null));
    checkLogin();
  }

  Future<void> checkTokenLogin() async {
    bool checkLogin = await loginUseCase.checkTokenLogin();
    if (checkLogin) {
      AppNavigator.go(Routes.home);
    }
  }

  void checkLogin() {
    emit(state.copyWith(
      isUsernameValid: RegexUtils.isUsernameValid(state.username),
      isPasswordValid: RegexUtils.isPasswordValid(state.password),
      error: null,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, error: null));
    checkLogin();
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> onTapLogin() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final fcmToken = await _getFcmToken() ?? 'default_token';
      final loginRequest = LoginRequest(
        phone: state.username,
        password: state.password,
        fcmToken: fcmToken,
      );
      final loginData = await loginUseCase.requestLogin(loginRequest);
      if (loginData.data?.accessToken != null) {
        await AppSecureStorage.setToken(TokenData(
          accessToken: loginData.data!.accessToken,
        ));
        await AppSP.set('account', loginData.data!.info["id"]);
        await AppSP.set('fcm_token', fcmToken);
        await AppSP.set('user_info', jsonEncode(loginData.data!.info));
        print('fcm user_info: ${jsonEncode(loginData.data!.info)}');
        print('fcm Token: ${fcmToken}');
        await AppSP.set('expired', loginData.data!.expired);

        AppNavigator.go(Routes.home);
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: loginData.data?.msg.toString(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('Lỗi khi lấy FCM token: $e');
      return null;
    }
  }
}
