import 'dart:io';

import 'package:core/core.dart';
import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/domains/entities/messege/messege_entities.dart';
import 'package:crm_gt/features/modules/messege/widgets/image_screen_item.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MessegeItem extends BaseWidget {
  final MessegeEntities mess;
  final bool showTime;
  final bool showDate;
  final bool showName;
  final bool forceShowTime;
  final VoidCallback? onLongPress;
  final bool isFirstInGroup; // New parameter to identify first Messege in group

  const MessegeItem({
    super.key,
    required this.mess,
    this.showTime = true,
    this.showDate = false,
    this.showName = true,
    this.forceShowTime = false,
    this.onLongPress,
    this.isFirstInGroup = false, // Default false
  });

  @override
  Widget build(BuildContext context) {
    final isMyMessege = AppSP.get('account').toString() == mess.userId;
    final hasFile = mess.fileUrl != null && mess.fileUrl!.isNotEmpty;
    final isImage = hasFile && (mess.fileType == 'image/jpeg' || mess.fileType == 'image/png');
    final sentAt = mess.sentAt != null ? DateTime.parse(mess.sentAt!).toLocal() : null;
    final timeFormatter = DateFormat('HH:mm');
    final shouldShowTime = showTime || forceShowTime;

    return Column(
      children: [
        // Date separator
        if (showDate && sentAt != null)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300], thickness: 0.5)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    formatDate(sentAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300], thickness: 0.5)),
              ],
            ),
          ),

        // Messege bubble
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
          child: Row(
            mainAxisAlignment: isMyMessege ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Timestamp bên trái cho tin nhắn nhận
              if (!isMyMessege && forceShowTime && sentAt != null)
                Container(
                  margin: const EdgeInsets.only(right: 6, bottom: 2),
                  child: AnimatedOpacity(
                    opacity: forceShowTime ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      timeFormatter.format(sentAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),

              // Messege content
              Flexible(
                child: GestureDetector(
                  onLongPress: onLongPress,
                  child: Column(
                    crossAxisAlignment:
                        isMyMessege ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Tên người gửi - chỉ hiển thị ở tin nhắn đầu tiên trong nhóm
                      if (!isMyMessege && mess.userName != null && isFirstInGroup)
                        Container(
                          margin: const EdgeInsets.only(left: 8, bottom: 2),
                          child: Text(
                            mess.userName!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      // Messege bubble
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                            minWidth: 0,
                          ),
                          decoration: BoxDecoration(
                            color: (hasFile && isImage)
                                ? Colors.transparent
                                : (isMyMessege
                                    ? app.AppColors.cempedak101
                                    : const Color(0xFFF0F0F0)),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: (hasFile && isImage)
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Hình ảnh
                              if (hasFile && isImage)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImageViewer(
                                            imageUrl: mess.fileUrl!,
                                            sentTime: mess.sentAt,
                                            senderName: mess.userName,
                                            fileName: mess.fileName),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                                        maxHeight: 300,
                                      ),
                                      child: Image.network(
                                        mess.fileUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            height: 150,
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                    isMyMessege
                                                        ? app.AppColors.mono0
                                                        : const Color(0xFF0084FF)),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 150,
                                          color: Colors.grey[100],
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red[400],
                                                size: 24,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Không thể tải ảnh',
                                                style: TextStyle(
                                                  color: Colors.red[400],
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // File đính kèm
                              if (hasFile && !isImage)
                                GestureDetector(
                                  onTap: () async {
                                    await _handleFileTap(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isMyMessege
                                          ? app.AppColors.mono0.withOpacity(0.2)
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isMyMessege
                                                ? app.AppColors.mono0.withOpacity(0.3)
                                                : app.AppColors.blueberry20,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            _getFileIcon(mess.fileType),
                                            size: 18,
                                            color: isMyMessege
                                                ? app.AppColors.mono0
                                                : Colors.blue[700],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                mess.fileName ?? 'File không xác định',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: isMyMessege
                                                      ? app.AppColors.mono0
                                                      : Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (mess.fileType != null)
                                                Text(
                                                  mess.fileType!.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isMyMessege
                                                        ? app.AppColors.mono0
                                                        : Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Nội dung tin nhắn
                              if (mess.messege != null && mess.messege!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: hasFile ? 4 : 8,
                                  ),
                                  child: Text(
                                    mess.messege!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.3,
                                      color: (hasFile && isImage)
                                          ? Colors.white
                                          : (isMyMessege ? app.AppColors.mono0 : Colors.black87),
                                    ),
                                  ),
                                ),

                              // Timestamp trong bubble (khi không force show)
                              // if (!forceShowTime && shouldShowTime && sentAt != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  bottom: 6,
                                  top: (mess.messege?.isEmpty ?? true) && !hasFile ? 6 : 2,
                                ),
                                child: Text(
                                  timeFormatter.format(sentAt!),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: (hasFile && isImage)
                                        ? Colors.white
                                        : (isMyMessege ? app.AppColors.mono0 : Colors.grey[500]),
                                  ),
                                  textAlign: isMyMessege ? TextAlign.right : TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Timestamp bên phải cho tin nhắn gửi
              if (isMyMessege && forceShowTime && sentAt != null)
                Container(
                  margin: const EdgeInsets.only(left: 6, bottom: 2),
                  child: AnimatedOpacity(
                    opacity: forceShowTime ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      timeFormatter.format(sentAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final MessegeDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(MessegeDate).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else {
      return DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(date);
    }
  }

  IconData _getFileIcon(String? fileType) {
    if (fileType == null) return Icons.insert_drive_file;

    final type = fileType.toLowerCase();
    if (type.startsWith('image/')) return Icons.image;
    if (type.startsWith('video/')) return Icons.video_file;
    if (type.startsWith('audio/')) return Icons.audio_file;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('document')) return Icons.description;
    if (type.contains('excel') || type.contains('spreadsheet')) return Icons.table_chart;
    if (type.contains('powerpoint') || type.contains('presentation')) return Icons.slideshow;
    if (type.contains('zip') || type.contains('rar')) return Icons.archive;

    return Icons.insert_drive_file;
  }

  /// Xử lý khi tap vào file an toàn cho iOS - Có sử dụng url_launcher an toàn
  Future<void> _handleFileTap(BuildContext context) async {
    try {
      // Kiểm tra fileUrl có tồn tại không
      if (mess.fileUrl == null || mess.fileUrl!.isEmpty) {
        // _showErrorSnackBar(context, 'File không tồn tại');
        return;
      }

      final fileUrl = mess.fileUrl!;

      // Kiểm tra xem có phải là file local không (iOS thường có đường dẫn local)
      if (fileUrl.startsWith('file://') || fileUrl.startsWith('/')) {
        // File local - kiểm tra file có tồn tại không
        final filePath = fileUrl.startsWith('file://')
            ? fileUrl.substring(7) // Bỏ 'file://'
            : fileUrl;

        final file = File(filePath);
        if (await file.exists()) {
          // _showInfoSnackBar(context, 'File local: ${path.basename(file.path)}');
        } else {
          // _showErrorSnackBar(context, 'File không tồn tại trên thiết bị');
        }
        return;
      }

      // Kiểm tra xem có phải là URL hợp lệ không
      if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
        // _showErrorSnackBar(context, 'Đường dẫn file không hợp lệ');
        return;
      }

      // Sử dụng url_launcher an toàn với try-catch
      try {
        final uri = Uri.parse(fileUrl);

        // Kiểm tra xem có thể mở URL không
        if (await canLaunchUrl(uri)) {
          // Mở URL trong trình duyệt
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
          // _showInfoSnackBar(context, 'Đã mở file trong trình duyệt');
        } else {
          // _showErrorSnackBar(context, 'Không thể mở file này');
        }
      } catch (urlError) {
        print('Lỗi khi mở URL: $urlError');
        // Fallback: hiển thị thông tin file
        final fileName = mess.fileName ?? 'File không xác định';
        final fileType = mess.fileType ?? 'Không xác định';
        // _showInfoSnackBar(context, 'File: $fileName ($fileType)');
        print('File URL: $fileUrl');
      }
    } catch (e) {
      print('Lỗi khi xử lý file: $e');
      // _showErrorSnackBar(context, 'Lỗi khi xử lý file: ${e.toString()}');
    }
  }
}
