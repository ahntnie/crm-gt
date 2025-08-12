part of '../core.dart';

/// Utility class for file-related operations
class FileUtils {
  /// Lấy màu icon dựa trên loại file
  static Color getFileIconColor(String? fileType) {
    if (fileType == null) return Colors.grey;

    if (fileType.startsWith('image/')) {
      return Colors.green;
    } else if (fileType.startsWith('video/')) {
      return Colors.red;
    } else if (fileType.startsWith('audio/')) {
      return Colors.orange;
    } else if (fileType.contains('pdf')) {
      return Colors.red[700]!;
    } else if (fileType.contains('word') || fileType.contains('document')) {
      return Colors.blue[700]!;
    } else if (fileType.contains('excel') || fileType.contains('spreadsheet')) {
      return Colors.green[700]!;
    } else if (fileType.contains('powerpoint') || fileType.contains('presentation')) {
      return Colors.orange[700]!;
    } else if (fileType.contains('text')) {
      return Colors.grey[700]!;
    } else if (fileType.contains('zip') ||
        fileType.contains('rar') ||
        fileType.contains('archive')) {
      return Colors.purple[700]!;
    } else {
      return Colors.grey;
    }
  }

  /// Lấy icon dựa trên loại file
  static IconData getFileIcon(String? fileType) {
    if (fileType == null) return Icons.insert_drive_file;

    if (fileType.startsWith('image/')) {
      return Icons.image;
    } else if (fileType.startsWith('video/')) {
      return Icons.video_file;
    } else if (fileType.startsWith('audio/')) {
      return Icons.audio_file;
    } else if (fileType.contains('pdf')) {
      return Icons.picture_as_pdf;
    } else if (fileType.contains('word') || fileType.contains('document')) {
      return Icons.description;
    } else if (fileType.contains('excel') || fileType.contains('spreadsheet')) {
      return Icons.table_chart;
    } else if (fileType.contains('powerpoint') || fileType.contains('presentation')) {
      return Icons.slideshow;
    } else if (fileType.contains('text')) {
      return Icons.text_snippet;
    } else if (fileType.contains('zip') ||
        fileType.contains('rar') ||
        fileType.contains('archive')) {
      return Icons.archive;
    } else {
      return Icons.insert_drive_file;
    }
  }

  /// Lấy màu icon dựa trên extension file
  static Color getFileIconColorFromExtension(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();

    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
      case '.bmp':
      case '.svg':
        return Colors.green;
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':
      case '.flv':
        return Colors.red;
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
        return Colors.orange;
      case '.pdf':
        return Colors.red[700]!;
      case '.doc':
      case '.docx':
        return Colors.blue[700]!;
      case '.xls':
      case '.xlsx':
        return Colors.green[700]!;
      case '.ppt':
      case '.pptx':
        return Colors.orange[700]!;
      case '.txt':
        return Colors.grey[700]!;
      case '.zip':
      case '.rar':
      case '.7z':
        return Colors.purple[700]!;
      default:
        return Colors.grey;
    }
  }

  /// Lấy icon dựa trên extension file
  static IconData getFileIconFromExtension(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();

    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
      case '.bmp':
      case '.svg':
        return Icons.image;
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':
      case '.flv':
        return Icons.video_file;
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
        return Icons.audio_file;
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.txt':
        return Icons.text_snippet;
      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Lấy extension từ tên file
  static String getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) return '';
    return fileName.substring(lastDotIndex);
  }

  /// Lấy tên file không có extension
  static String getFileNameWithoutExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) return fileName;
    return fileName.substring(0, lastDotIndex);
  }

  /// Format kích thước file
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Kiểm tra xem file có phải là hình ảnh không (dựa trên extension)
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg'].contains(extension);
  }

  /// Kiểm tra xem file có phải là video không
  static bool isVideoFile(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();
    return ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', '.webm'].contains(extension);
  }

  /// Kiểm tra xem file có phải là audio không
  static bool isAudioFile(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();
    return ['.mp3', '.wav', '.flac', '.aac', '.ogg', '.wma'].contains(extension);
  }
}
