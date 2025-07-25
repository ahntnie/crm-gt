import 'package:crm_gt/domains/entities/dir/dir_entities.dart';

abstract class HomeRepo {
  Future<List<DirEntities>> getAllDir();
  Future<List<DirEntities>> getDirByLevel(String level);
  Future<List<DirEntities>> getDirByParentId(String parentId);
  Future<DirEntities> getDirById(String id);
  Future<String> invatedToChat(String id, String phone);
  Future<bool> createDir(String nameDir, String createBy);
}
