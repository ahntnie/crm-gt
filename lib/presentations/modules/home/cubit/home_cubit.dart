import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  HomeCubit() : super(HomeInitial());

  Future<void> getAllDir() async {
    final listDir = await homeUsecase.getAllDir();
    print('Lengthttt: ${listDir.length}');
  }
}
