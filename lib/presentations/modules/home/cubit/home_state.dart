part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<DirEntities> listDir;
  const HomeState({
    this.listDir = const [],
  });

  @override
  List<Object> get props => [listDir];
  HomeState copyWith({
    List<DirEntities>? listDir,
  }) {
    return HomeState(
      listDir: listDir ?? this.listDir,
    );
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super();
}
