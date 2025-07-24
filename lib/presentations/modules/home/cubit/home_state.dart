part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<DirEntities> listDir;
  final DirEntities? currentDir;
  const HomeState({this.listDir = const [], this.currentDir});

  @override
  List<Object?> get props => [listDir, currentDir];

  HomeState copyWith({
    List<DirEntities>? listDir,
    DirEntities? currentDir,
  }) {
    return HomeState(
      listDir: listDir ?? this.listDir,
      currentDir: currentDir,
    );
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super();
}
