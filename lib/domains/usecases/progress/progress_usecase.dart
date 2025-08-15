import 'package:crm_gt/data/models/request/progress/create_progress_request.dart';
import 'package:crm_gt/data/models/request/progress/update_progress_request.dart';
import 'package:crm_gt/domains/entities/progress/progress_entities.dart';
import 'package:crm_gt/domains/repositories/progress/progress_repo.dart';

class ProgressUsecase {
  final ProgressRepo _repo;
  ProgressUsecase(this._repo);

  Future<String> createProgress(CreateProgressRequest request) async {
    return await _repo.createProgress(request);
  }

  Future<bool> updateProgress(UpdateProgressRequest request) async {
    return await _repo.updateProgress(request);
  }

  Future<ProgressEntity> getProgressById(String id) async {
    return await _repo.getProgressById(id);
  }

  Future<List<ProgressEntity>> getProgressByDirId(String dirId) async {
    return await _repo.getProgressByDirId(dirId);
  }
}
