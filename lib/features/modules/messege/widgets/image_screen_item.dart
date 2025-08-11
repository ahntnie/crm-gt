import 'dart:io';

import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/widgets/swipe_back_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? senderName;
  final String? sentTime;
  final String? fileName;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.senderName,
    this.sentTime,
    this.fileName,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final ValueNotifier<bool> _isDownloading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isSharing = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.mono0,
              size: 22,
            ),
          ),
          tooltip: 'Đóng',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showOptionsBottomSheet(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                color: AppColors.mono0,
                size: 22,
              ),
            ),
            tooltip: 'Tùy chọn',
          ),
        ],
      ),
      body: SwipeBackWrapper(
        onSwipeBack: () => Navigator.pop(context),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Hero(
              tag: widget.imageUrl,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                initialScale: PhotoViewComputedScale.contained,
                loadingBuilder: (context, event) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mono0),
                        value: event == null
                            ? null
                            : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải ảnh...',
                        style: TextStyle(
                          color: AppColors.mono0.withOpacity(0.9),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: AppColors.mono0.withOpacity(0.8),
                        size: 72,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Không thể tải ảnh',
                        style: TextStyle(
                          color: AppColors.mono0.withOpacity(0.9),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Vui lòng kiểm tra kết nối mạng và thử lại.',
                        style: TextStyle(
                          color: AppColors.mono0.withOpacity(0.7),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.mono0,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isDownloading,
                builder: (context, isDownloading, child) {
                  return ListTile(
                    leading: isDownloading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Icon(Icons.download_for_offline_outlined,
                            color: Colors.blue, size: 28),
                    title: Text(
                      isDownloading ? 'Đang tải xuống...' : 'Tải xuống',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: isDownloading ? Colors.grey : Colors.black87,
                      ),
                    ),
                    onTap: isDownloading
                        ? null
                        : () {
                            Navigator.pop(context);
                            _downloadImage();
                          },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.orange, size: 28),
                title: const Text(
                  'Thông tin ảnh',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showImageInfo(context);
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isSharing,
                builder: (context, isSharing, child) {
                  return ListTile(
                    leading: isSharing
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Icon(Icons.share, color: Colors.green, size: 28),
                    title: Text(
                      isSharing ? 'Đang chia sẻ...' : 'Chia sẻ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: isSharing ? Colors.grey : Colors.black87,
                      ),
                    ),
                    onTap: isSharing
                        ? null
                        : () {
                            Navigator.pop(context);
                            _shareImage();
                          },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadImage() async {
    if (_isDownloading.value) return;

    _isDownloading.value = true;

    try {
      final dio = Dio();
      final response = await dio.get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getApplicationDocumentsDirectory();
      final fileName = widget.fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = path.join(directory.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tải xuống: $fileName'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải xuống: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        _isDownloading.value = false;
      }
    }
  }

  Future<void> _shareImage() async {
    if (_isSharing.value) return;

    _isSharing.value = true;

    try {
      final dio = Dio();
      final response = await dio.get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getTemporaryDirectory();
      final fileName = widget.fileName ?? 'image_to_share.jpg';
      final filePath = path.join(directory.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      await Share.shareXFiles([XFile(filePath)], text: 'Kiểm tra ảnh này!');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Đã chia sẻ ảnh.'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chia sẻ: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        _isSharing.value = false;
      }
    }
  }

  void _showImageInfo(BuildContext context) {
    final fileExtension = path.extension(widget.imageUrl).toLowerCase();
    final fileType = _getFileType(fileExtension);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Thông tin ảnh',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Loại file:', fileType),
            if (widget.fileName != null && widget.fileName!.isNotEmpty)
              _buildInfoRow('Tên file:', widget.fileName!),
            if (widget.senderName != null && widget.senderName!.isNotEmpty)
              _buildInfoRow('Người gửi:', widget.senderName!),
            if (widget.sentTime != null && widget.sentTime!.isNotEmpty)
              _buildInfoRow('Thời gian gửi:', _formatDateTime(DateTime.parse(widget.sentTime!))),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cempedak101,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              minimumSize: const Size(120, 45),
            ),
            child: const Text(
              'Đóng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileType(String extension) {
    switch (extension) {
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
      default:
        return 'Tệp ảnh';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _isDownloading.dispose();
    _isSharing.dispose();
    super.dispose();
  }
}
