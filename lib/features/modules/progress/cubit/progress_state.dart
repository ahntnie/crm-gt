part of 'progress_cubit.dart';

class ProgressState extends Equatable {
  final List<ProgressEntity> progressList;
  final ProgressEntity? selectedProgress;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final String? error;
  final String? successMessage;
  final bool isAdmin;

  // Form fields
  final String title;
  final String description;
  final String expectedCompletionDate;
  final double completionPercentage;
  final bool isFormValid;

  const ProgressState({
    this.progressList = const [],
    this.selectedProgress,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.error,
    this.successMessage,
    this.isAdmin = false,
    this.title = '',
    this.description = '',
    this.expectedCompletionDate = '',
    this.completionPercentage = 0.0,
    this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        progressList,
        selectedProgress,
        isLoading,
        isCreating,
        isUpdating,
        error,
        successMessage,
        isAdmin,
        title,
        description,
        expectedCompletionDate,
        completionPercentage,
        isFormValid,
      ];

  ProgressState copyWith({
    List<ProgressEntity>? progressList,
    ProgressEntity? selectedProgress,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    String? error,
    String? successMessage,
    bool? isAdmin,
    String? title,
    String? description,
    String? expectedCompletionDate,
    double? completionPercentage,
    bool? isFormValid,
  }) {
    return ProgressState(
      progressList: progressList ?? this.progressList,
      selectedProgress: selectedProgress,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      successMessage: successMessage,
      isAdmin: isAdmin ?? this.isAdmin,
      title: title ?? this.title,
      description: description ?? this.description,
      expectedCompletionDate: expectedCompletionDate ?? this.expectedCompletionDate,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}

class ProgressInitial extends ProgressState {
  const ProgressInitial() : super();
}
