import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/core/utils/role_utils.dart';
import 'package:crm_gt/data/models/request/progress/create_progress_request.dart';
import 'package:crm_gt/data/models/request/progress/update_progress_request.dart';
import 'package:crm_gt/domains/entities/progress/progress_entities.dart';
import 'package:crm_gt/domains/usecases/progress/progress_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final progressUseCase = getIt.get<ProgressUsecase>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;

  ProgressCubit() : super(const ProgressInitial()) {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    _checkAdminRole();
  }

  void _checkAdminRole() {
    final isAdmin = RoleUtils.isAdmin();
    emit(state.copyWith(isAdmin: isAdmin));
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    return super.close();
  }

  void titleChanged(String value) {
    emit(state.copyWith(title: value, error: null));
    _validateForm();
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, error: null));
    _validateForm();
  }

  void dateChanged(String value) {
    emit(state.copyWith(expectedCompletionDate: value, error: null));
    _validateForm();
  }

  void percentageChanged(double value) {
    emit(state.copyWith(completionPercentage: value, error: null));
  }

  void _validateForm() {
    bool isValid = state.title.isNotEmpty && state.expectedCompletionDate.isNotEmpty;
    emit(state.copyWith(isFormValid: isValid));
  }

  Future<void> loadProgressByDirId(String dirId) async {
    if (state.isLoading) return;
    print('loadProgressByDirId: $dirId');
    emit(state.copyWith(isLoading: true, error: null));
    print('zbc');
    try {
      final progressList = await progressUseCase.getProgressByDirId(dirId);
      print('progressList: $progressList');
      emit(state.copyWith(
        progressList: progressList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      print('error: $e');
    }
  }

  Future<void> loadProgressById(String id) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final progress = await progressUseCase.getProgressById(id);
      emit(state.copyWith(
        selectedProgress: progress,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> createProgress(String dirId) async {
    if (!state.isFormValid || state.isCreating || !state.isAdmin) {
      if (!state.isAdmin) {
        emit(state.copyWith(error: 'Chỉ admin mới có thể tạo tiến độ'));
      }
      return;
    }

    emit(state.copyWith(isCreating: true, error: null));

    try {
      final request = CreateProgressRequest(
        title: state.title,
        description: state.description,
        expectedCompletionDate: state.expectedCompletionDate,
        dirId: dirId,
      );

      await progressUseCase.createProgress(request);

      emit(state.copyWith(
        isCreating: false,
        successMessage: 'Tạo tiến độ thành công!',
      ));

      // Clear form
      _clearForm();

      // Reload progress list (don't override success state)
      final progressList = await progressUseCase.getProgressByDirId(dirId);
      print('progressList: $progressList');
      emit(state.copyWith(
        progressList: progressList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isCreating: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> updateProgressPercentage(String progressId, String percentage) async {
    if (state.isUpdating || !state.isAdmin) {
      if (!state.isAdmin) {
        emit(state.copyWith(error: 'Chỉ admin mới có thể cập nhật tiến độ'));
      }
      return;
    }

    emit(state.copyWith(isUpdating: true, error: null));

    try {
      final request = UpdateProgressRequest(
        progressId: progressId,
        completionPercentage: percentage,
      );

      final success = await progressUseCase.updateProgress(request);

      if (success) {
        // Update local state
        final updatedList = state.progressList.map((progress) {
          if (progress.id == progressId) {
            return ProgressEntity(
              id: progress.id,
              title: progress.title,
              description: progress.description,
              expectedCompletionDate: progress.expectedCompletionDate,
              completionPercentage: percentage,
              createdBy: progress.createdBy,
              createdAt: progress.createdAt,
              updatedAt: DateTime.now().toIso8601String(),
              dirId: progress.dirId,
              createdByName: progress.createdByName,
              dirName: progress.dirName,
            );
          }
          return progress;
        }).toList();

        emit(state.copyWith(
          progressList: updatedList,
          isUpdating: false,
          successMessage: 'Cập nhật tiến độ thành công!',
        ));
      } else {
        emit(state.copyWith(
          isUpdating: false,
          error: 'Không thể cập nhật tiến độ',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();

    emit(state.copyWith(
      title: '',
      description: '',
      expectedCompletionDate: '',
      completionPercentage: 0.0,
      isFormValid: false,
    ));
  }

  void clearForm() {
    _clearForm();
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void clearSuccessMessage() {
    emit(state.copyWith(successMessage: null));
  }
}
