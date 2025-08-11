part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<DirEntities> listDir;
  final DirEntities? currentDir;
  final String? phone;
  final String? nameDir;
  final bool isLoading;
  final UserEntities? userInfo;
  const HomeState(
      {this.isLoading = false,
      this.listDir = const [],
      this.currentDir,
      this.phone,
      this.userInfo,
      this.nameDir});

  @override
  List<Object?> get props => [listDir, currentDir, phone, nameDir];

  HomeState copyWith({
    List<DirEntities>? listDir,
    bool? isLoading,
    DirEntities? currentDir,
    String? phone,
    String? nameDir,
    UserEntities? userInfo,
  }) {
    return HomeState(
      listDir: listDir ?? this.listDir,
      currentDir: currentDir,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      nameDir: nameDir ?? this.nameDir,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super();
}
