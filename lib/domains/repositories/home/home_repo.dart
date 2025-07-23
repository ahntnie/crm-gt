import 'package:crm_gt/domains/entities/dir/dir_entities.dart';

abstract class HomeRepo {
  Future<List<DirEntities>> getAllDir();
}
