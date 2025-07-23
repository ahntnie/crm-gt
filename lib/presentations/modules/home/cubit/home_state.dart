part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int index;
  const HomeState({this.index = 0});

  @override
  List<Object> get props => [index];
  HomeState copyWith({int index = 0}) {
    return  HomeState(index: index);
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super();
}
