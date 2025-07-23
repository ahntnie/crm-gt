import 'package:core/core.dart';
import 'package:crm_gt/data/models/request/authentication/login_request.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final loginUseCase = getIt.get<LoginUsecase>();
  late final usernameController = TextEditingController(text: state.username);
  late final passwordController = TextEditingController(text: state.password);
  LoginCubit() : super(LoginInitial());
  void usernameChanged(String value) {
    emit(state.copyWith(username: value));
    checkLogin();
  }

  void checkLogin() {
    emit(state.copyWith(
      isUsernameValid: RegexUtils.isUsernameValid(state.username),
      isPasswordValid: RegexUtils.isPasswordValid(state.password),
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
    checkLogin();
  }

  Future<void> onTapLogin() async {
    print('hahahaha');
    final loginRequest =
        LoginRequest(phone: state.username, password: state.password, fcmToken: 'tien ngu');
    final loginData = await loginUseCase.requestLogin(loginRequest);
    if (loginData.data?.accessToken != null) {
      AppSecureStorage.setToken(TokenData(
        accessToken: loginData.data?.accessToken,
      ));
      AppSP.set('account', state.username);
      AppNavigator.go(Routes.home);
    }
  }
}
