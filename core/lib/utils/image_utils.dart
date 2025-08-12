part of '../core.dart';

/// Utility class for image-related operations
class ImageUtils {
  /// Headers để khắc phục vấn đề tải ảnh trên iOS và cải thiện compatibility
  static Map<String, String> getImageHeaders() {
    return {
      'User-Agent': 'CRM-GT Mobile App',
      'Accept': 'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Accept-Encoding': 'gzip, deflate, br',
      'Cache-Control': 'no-cache',
      if (Platform.isIOS) ...{
        'Accept-Language': 'vi-VN,vi;q=0.9,en;q=0.8',
        'Sec-Fetch-Dest': 'image',
        'Sec-Fetch-Mode': 'no-cors',
        'Sec-Fetch-Site': 'cross-site',
      },
    };
  }

  /// Kiểm tra xem file có phải là hình ảnh không
  static bool isImageFile(String? fileType) {
    if (fileType == null) return false;
    return fileType.startsWith('image/') ||
        fileType == 'image/jpeg' ||
        fileType == 'image/png' ||
        fileType == 'image/gif' ||
        fileType == 'image/webp' ||
        fileType == 'image/bmp';
  }

  /// Kiểm tra xem đường dẫn file có phải là hình ảnh không (dựa trên extension)
  static bool isImagePath(String filePath) {
    final extension = filePath.toLowerCase();
    return extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.png') ||
        extension.endsWith('.gif') ||
        extension.endsWith('.webp') ||
        extension.endsWith('.bmp');
  }

  /// Lấy loại file từ extension
  static String getFileTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'Ảnh JPEG';
      case '.png':
        return 'Ảnh PNG';
      case '.gif':
        return 'Ảnh GIF';
      case '.webp':
        return 'Ảnh WebP';
      case '.bmp':
        return 'Ảnh BMP';
      case '.svg':
        return 'Ảnh SVG';
      default:
        return 'Tệp ảnh';
    }
  }
}
