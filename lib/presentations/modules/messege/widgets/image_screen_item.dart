import 'package:crm_gt/apps/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.mono0,
              size: 20,
            ),
          ),
          tooltip: 'Đóng',
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add share functionality here
              _showOptionsBottomSheet(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                color: AppColors.mono0,
                size: 20,
              ),
            ),
            tooltip: 'Tùy chọn',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
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
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.mono0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải ảnh...',
                      style: TextStyle(
                        color: AppColors.mono0.withOpacity(0.8),
                        fontSize: 16,
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
                      Icons.error_outline,
                      color: AppColors.mono0.withOpacity(0.8),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không thể tải ảnh',
                      style: TextStyle(
                        color: AppColors.mono0.withOpacity(0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vui lòng thử lại sau',
                      style: TextStyle(
                        color: AppColors.mono0.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.blue),
                title: const Text('Tải xuống'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement download functionality
                  _downloadImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                  _shareImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.orange),
                title: const Text('Thông tin ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  // Show image info
                  _showImageInfo(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadImage() {
    // Implement download functionality
    debugPrint('Download image: $imageUrl');
  }

  void _shareImage() {
    // Implement share functionality
    debugPrint('Share image: $imageUrl');
  }

  void _showImageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin ảnh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('URL: $imageUrl'),
            // Add more image info here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
