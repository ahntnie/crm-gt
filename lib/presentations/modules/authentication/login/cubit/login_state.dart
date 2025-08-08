part of 'login_cubit.dart';

 class LoginState extends Equatable {
  final String username;
  final String password;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isLoading;
  final String? error;
  final bool isPasswordVisible;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isUsernameValid = false,
    this.isPasswordValid = false,
    this.isLoading = false,
    this.error,
    this.isPasswordVisible = false,
  });

  @override
  List<Object?> get props => [
        username,
        password,
        isUsernameValid,
        isPasswordValid,
        isLoading,
        error,
        isPasswordVisible,
      ];

  LoginState copyWith({
    String? username,
    String? password,
    bool? isUsernameValid,
    bool? isPasswordValid,
    bool? isLoading,
    String? error,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class LoginInitial extends LoginState {
  const LoginInitial() : super();
}
