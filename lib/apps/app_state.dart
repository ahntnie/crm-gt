part of 'app_cubit.dart';

class AppState extends CoreState {
  final Locale? locale;
  // final UserInformationEntity? userInfo;

  const AppState({
    this.locale,
    // this.userInfo,
  });

  @override
  List<Object?> get props => [
        locale,
      ];

  AppState copyWith({
    Locale? locale,
  }) {
    return AppState(
      locale: locale ?? this.locale,
    );
  }
}

final class AppInitial extends AppState {
  const AppInitial() : super();
}
