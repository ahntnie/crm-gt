class CreateProgressRequest {
  String title;
  String description;
  String expectedCompletionDate;
  String dirId;
  CreateProgressRequest(
      {required this.title,
      required this.description,
      required this.expectedCompletionDate,
      required this.dirId});

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "expected_completion_date": expectedCompletionDate,
        "dir_id": dirId,
      };
}
