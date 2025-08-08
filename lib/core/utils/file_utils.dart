import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class FileUtils {
  /// Chọn file an toàn cho cả iOS và Android
  static Future<List<File>> pickFiles({
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    bool allowMultiple = true,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: true, // Đảm bảo bytes có sẵn trên iOS
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      final List<File> pickedFiles = [];

      for (final platformFile in result.files) {
        try {
          File? file;

          // Ưu tiên sử dụng path nếu có
          if (platformFile.path != null && platformFile.path!.isNotEmpty) {
            file = File(platformFile.path!);
            if (await file.exists()) {
              pickedFiles.add(file);
              continue;
            }
          }

          // Nếu không có path hoặc file không tồn tại, sử dụng bytes
          if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
            final tempDir = Directory.systemTemp;
            final fileName = platformFile.name.isNotEmpty
                ? platformFile.name
                : 'file_${DateTime.now().millisecondsSinceEpoch}';
            final tempPath = path.join(tempDir.path, fileName);
            final tempFile = File(tempPath);

            await tempFile.writeAsBytes(platformFile.bytes!, flush: true);
            pickedFiles.add(tempFile);
          }
        } catch (e) {
          print('Lỗi xử lý file ${platformFile.name}: $e');
          // Tiếp tục với file tiếp theo thay vì dừng toàn bộ
        }
      }

      return pickedFiles;
    } catch (e) {
      print('Lỗi chọn file: $e');
      return [];
    }
  }

  /// Encode file thành base64 an toàn
  static Future<String?> encodeFileToBase64(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('File không tồn tại: $filePath');
        return null;
      }

      final fileSize = await file.length();
      // Giới hạn kích thước file (10MB)
      if (fileSize > 10 * 1024 * 1024) {
        print('File quá lớn: ${fileSize} bytes');
        return null;
      }

      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Lỗi encode file $filePath: $e');
      return null;
    }
  }

  /// Lấy MIME type của file
  static String getFileType(File file) {
    final extension = path.extension(file.path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.txt':
        return 'text/plain';
      case '.mp4':
        return 'video/mp4';
      case '.mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

  /// Kiểm tra file có phải là hình ảnh không
  static bool isImageFile(File file) {
    final extension = path.extension(file.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
  }

  /// Lấy tên file từ đường dẫn
  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  /// Lấy extension của file
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// Kiểm tra kích thước file có hợp lệ không
  static Future<bool> isValidFileSize(String filePath, {int maxSizeMB = 10}) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;
      
      final fileSize = await file.length();
      return fileSize <= maxSizeMB * 1024 * 1024;
    } catch (e) {
      return false;
    }
  }

  /// Xóa file tạm
  static Future<void> deleteTempFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Lỗi xóa file tạm $filePath: $e');
    }
  }

  /// Xóa nhiều file tạm
  static Future<void> deleteTempFiles(List<String> filePaths) async {
    for (final filePath in filePaths) {
      await deleteTempFile(filePath);
    }
  }
}
