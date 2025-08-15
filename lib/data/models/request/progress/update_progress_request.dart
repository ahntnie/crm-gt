class UpdateProgressRequest {
  String progressId;
  String completionPercentage;

  UpdateProgressRequest({
    required this.progressId,
    required this.completionPercentage,
  });

  Map<String, dynamic> toJson() => {
        "progress_id": progressId,
        "completion_percentage": completionPercentage,
      };
}
