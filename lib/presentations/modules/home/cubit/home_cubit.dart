import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

void incrementIndex() {
    emit(state.copyWith(index: state.index + 1));
  }

  void decrementIndex() {
    emit(state.copyWith(index: state.index - 1));
  }

  void resetIndex() {
    emit(const HomeInitial());
  }
  
}
