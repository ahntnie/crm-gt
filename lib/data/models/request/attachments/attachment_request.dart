class AttachmentRequest {
  String threadId;
  List<String> files;
  AttachmentRequest({
    required this.threadId,
    required this.files,
  });

  Map<String, dynamic> toJson() => {
        "thread_id": threadId,
        "files[]": files,
      };
}
