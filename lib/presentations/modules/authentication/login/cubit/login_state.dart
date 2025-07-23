part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final bool isUsernameValid;
  final bool isPasswordValid;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isUsernameValid = false,
    this.isPasswordValid = false,
  });
  @override
  List<Object?> get props => [
        username,
        password,
        isUsernameValid,
        isPasswordValid,
      ];
  LoginState copyWith({
    String? username,
    String? password,
    bool? isUsernameValid,
    bool? isPasswordValid,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}

final class LoginInitial extends LoginState {}
