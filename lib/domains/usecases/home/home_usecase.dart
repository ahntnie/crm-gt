import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/repositories/home/home_repo.dart';

class HomeUsecase {
  final HomeRepo _repo;
  HomeUsecase(this._repo);
  Future<List<DirEntities>> getAllDir() async {
    return await _repo.getAllDir();
  }
}
