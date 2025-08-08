import 'package:crm_gt/apps/app_colors.dart';
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
              color: _getFileIconColor(file.fileName).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getFileIcon(file.fileName),
              color: _getFileIconColor(file.fileName),
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
                      _formatUploadTime(file.uploadedAt),
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
                  color: AppColors.cempedak101.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _handleDownload(context, file),
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 18,
                  ),
                  color: AppColors.cempedak101,
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
  IconData _getFileIcon(String? fileName) {
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
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileIconColor(String? fileName) {
    if (fileName == null) return Colors.grey;

    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red[600]!;
      case 'doc':
      case 'docx':
        return Colors.blue[600]!;
      case 'xls':
      case 'xlsx':
        return Colors.green[600]!;
      case 'ppt':
      case 'pptx':
        return Colors.orange[600]!;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple[600]!;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Colors.indigo[600]!;
      case 'mp3':
      case 'wav':
        return Colors.pink[600]!;
      case 'zip':
      case 'rar':
        return Colors.brown[600]!;
      case 'txt':
        return Colors.teal[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatUploadTime(String? uploadedAt) {
    if (uploadedAt == null || uploadedAt.isEmpty) {
      return 'Không rõ thời gian';
    }

    try {
      final dateTime = DateTime.parse(uploadedAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } else if (difference.inDays > 0) {
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

  String _formatFileSize(dynamic fileSize) {
    if (fileSize == null) return '';

    try {
      final size = fileSize is String ? int.tryParse(fileSize) ?? 0 : fileSize as int;

      if (size < 1024) {
        return '${size}B';
      } else if (size < 1024 * 1024) {
        return '${(size / 1024).toStringAsFixed(1)}KB';
      } else if (size < 1024 * 1024 * 1024) {
        return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
      } else {
        return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
      }
    } catch (e) {
      return '';
    }
  }

  void _handlePreview(BuildContext context, AttachmentEntities file) async {
    final fileName = file.fileName?.toLowerCase() ?? '';
    final fileUrl = file.fileUrl;
    if (fileUrl == null || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không tìm thấy file!')));
      return;
    }
    if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png') ||
        fileName.endsWith('.gif')) {
      // Xem trước ảnh
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 320,
              height: 320,
              child: PhotoView(
                imageProvider: NetworkImage(fileUrl),
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
        ),
      );
    } else if (fileName.endsWith('.pdf')) {
      // Mở PDF trên trình duyệt
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Không mở được file PDF!')));
      }
    } else {
      // Mở file khác trên trình duyệt
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Không mở được file!')));
      }
    }
  }

  void _handleDownload(BuildContext context, AttachmentEntities file) async {
    final fileUrl = file.fileUrl;
    if (fileUrl == null || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không tìm thấy file!')));
      return;
    }
    // Mở link file trên trình duyệt để tải về (có thể thay bằng logic tải file thực tế nếu muốn)
    if (await canLaunchUrl(Uri.parse(fileUrl))) {
      await launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không tải được file!')));
    }
  }
}
