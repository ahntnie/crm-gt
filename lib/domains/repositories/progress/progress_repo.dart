import 'package:crm_gt/data/models/request/progress/create_progress_request.dart';
import 'package:crm_gt/data/models/request/progress/update_progress_request.dart';
import 'package:crm_gt/domains/entities/progress/progress_entities.dart';

abstract class ProgressRepo {
  Future<String> createProgress(CreateProgressRequest request);
  Future<bool> updateProgress(UpdateProgressRequest request);
  Future<ProgressEntity> getProgressById(String id);
  Future<List<ProgressEntity>> getProgressByDirId(String dirId);
}
