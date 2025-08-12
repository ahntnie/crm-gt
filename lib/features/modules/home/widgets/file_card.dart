import 'package:core/core.dart';
import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FileCard extends StatelessWidget {
  final AttachmentEntities file;
  final VoidCallback? onTap;

  const FileCard({Key? key, required this.file, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FileUtils.getFileIconColorFromExtension(file.fileName ?? '').withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              FileUtils.getFileIconFromExtension(file.fileName ?? ''),
              color: FileUtils.getFileIconColorFromExtension(file.fileName ?? ''),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName ?? 'Không tên',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateTimeUtils.formatUploadTimeFromString(file.uploadedAt ?? ''),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // View button
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _handlePreview(context, file),
                  icon: const Icon(
                    Icons.visibility,
                    size: 18,
                  ),
                  color: Colors.blue[600],
                  tooltip: 'Xem file',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Download button
              Container(
                decoration: BoxDecoration(
                  color: app.AppColors.cempedak101.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _handleDownload(context, file),
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 18,
                  ),
                  color: app.AppColors.cempedak101,
                  tooltip: 'Tải xuống',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _handlePreview(BuildContext context, AttachmentEntities file) async {
    try {
      final fileName = file.fileName?.toLowerCase() ?? '';
      final fileUrl = file.fileUrl;
      if (Utils.isNullOrEmpty(fileUrl)) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Không tìm thấy file!')));
        return;
      }

      if (ImageUtils.isImagePath(fileName)) {
        // Xem trước ảnh
        await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 320,
                height: 320,
                child: PhotoView(
                  imageProvider: NetworkImage(
                    fileUrl!,
                    headers: ImageUtils.getImageHeaders(),
                  ),
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        );
      } else {
        // Sử dụng url_launcher an toàn với try-catch
        try {
          final uri = Uri.parse(fileUrl!);

          // Kiểm tra xem có thể mở URL không
          if (await canLaunchUrl(uri)) {
            // Mở URL trong trình duyệt
            await launchUrl(
              uri,
              mode: LaunchMode.inAppWebView,
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: const Text('Đã mở file trong trình duyệt'),
            //     backgroundColor: Colors.green[400],
            //     behavior: SnackBarBehavior.floating,
            //     duration: const Duration(seconds: 2),
            //   ),
            // );
          } else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: const Text('Không thể mở file này'),
            //     backgroundColor: Colors.red[400],
            //     behavior: SnackBarBehavior.floating,
            //   ),
            // );
          }
        } catch (urlError) {
          print('Lỗi khi mở URL: $urlError');
          // Fallback: hiển thị thông tin file
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('File: ${file.fileName ?? 'Không xác định'}'),
          //     backgroundColor: Colors.blue[400],
          //     behavior: SnackBarBehavior.floating,
          //     duration: const Duration(seconds: 2),
          //   ),
          // );
          print('File URL: $fileUrl');
        }
      }
    } catch (e) {
      print('Lỗi khi xử lý file: $e');
      // // ScaffoldMessenger.of(context).showSnackBar(
      // //   SnackBar(
      // //     content: Text('Lỗi khi xử lý file: ${e.toString()}'),
      // //     backgroundColor: Colors.red[400],
      // //     behavior: SnackBarBehavior.floating,
      // //   ),
      // );
    }
  }

  void _handleDownload(BuildContext context, AttachmentEntities file) async {
    try {
      final fileUrl = file.fileUrl;
      if (Utils.isNullOrEmpty(fileUrl)) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Không tìm thấy file!')));
        return;
      }
      try {
        final uri = Uri.parse(fileUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: const Text('Đã mở file trong trình duyệt để tải'),
          //     backgroundColor: Colors.green[400],
          //     behavior: SnackBarBehavior.floating,
          //     duration: const Duration(seconds: 2),
          //   ),
          // );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: const Text('Không thể tải file này'),
          //     backgroundColor: Colors.red[400],
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );
        }
      } catch (urlError) {
        print('Lỗi khi tải file: $urlError');
        // Fallback: hiển thị thông tin file
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Tải file: ${file.fileName ?? 'Không xác định'}'),
        //     backgroundColor: Colors.blue[400],
        //     behavior: SnackBarBehavior.floating,
        //     duration: const Duration(seconds: 2),
        //   ),
        // );
        print('Download URL: $fileUrl');
      }
    } catch (e) {
      print('Lỗi khi tải file: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Lỗi khi tải file: ${e.toString()}'),
      //     backgroundColor: Colors.red[400],
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );
    }
  }
}
