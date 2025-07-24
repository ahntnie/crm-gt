import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  HomeCubit() : super(const HomeInitial());

  Future<List<DirEntities>> getAllDir() async {
    final listDir = await homeUsecase.getAllDir();
    return listDir;
  }

  Future<List<DirEntities>> getDirByLevel(String level) async {
    final listDir = await homeUsecase.getDirByLevel(level);
    emit(state.copyWith(listDir: listDir));
    return listDir;
  }

  Future<List<DirEntities>> getDirByParentId(String parentId) async {
    final listDir = await homeUsecase.getDirByParentId(parentId);
    emit(state.copyWith(listDir: listDir, currentDir: state.currentDir));
    return listDir;
  }

  void changeCurrentDir(DirEntities? dir) {
    print('Vào change: ${dir?.name}');
    emit(state.copyWith(currentDir: dir));
  }

  Future<void> getCurrentDir(String? id) async {
    if (id != null) {
      DirEntities currentDir = await homeUsecase.getDirById(id);
      emit(state.copyWith(currentDir: currentDir));
    } else {
      print('Vô elseee');
      emit(state.copyWith(currentDir: null));
    }
  }

  Future<void> getInit() async {
    final listDir =
        await getDirByLevel(state.currentDir == null ? '0' : state.currentDir!.level.toString());
    emit(state.copyWith(listDir: listDir));
  }
}
