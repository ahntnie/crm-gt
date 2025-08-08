import 'package:flutter/material.dart';

IconData getFileIcon(String? fileName) {
  if (fileName == null) return Icons.insert_drive_file;

  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'xls':
    case 'xlsx':
      return Icons.table_chart;
    case 'ppt':
    case 'pptx':
      return Icons.slideshow;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Icons.image;
    case 'mp4':
    case 'avi':
    case 'mov':
      return Icons.video_file;
    case 'mp3':
    case 'wav':
      return Icons.audio_file;
    case 'zip':
    case 'rar':
      return Icons.archive;
    default:
      return Icons.insert_drive_file;
  }
}

Color getFileIconColor(String? fileName) {
  if (fileName == null) return Colors.grey;

  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Colors.red;
    case 'doc':
    case 'docx':
      return Colors.blue;
    case 'xls':
    case 'xlsx':
      return Colors.green;
    case 'ppt':
    case 'pptx':
      return Colors.orange;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Colors.purple;
    case 'mp4':
    case 'avi':
    case 'mov':
      return Colors.indigo;
    case 'mp3':
    case 'wav':
      return Colors.pink;
    case 'zip':
    case 'rar':
      return Colors.brown;
    default:
      return Colors.grey;
  }
}

String formatUploadTime(String? uploadedAt) {
  if (uploadedAt == null || uploadedAt.isEmpty) {
    return 'Không rõ thời gian';
  }

  try {
    final dateTime = DateTime.parse(uploadedAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  } catch (e) {
    return uploadedAt;
  }
}
