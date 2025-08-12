import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class OptimizedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final String? senderName;
  final String? sentTime;
  final String? fileName;

  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.senderName,
    this.sentTime,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                width: width,
                height: height,
                httpHeaders: ImageUtils.getImageHeaders(),
                errorWidget: (context, url, error) {
                  // Bỏ qua lỗi tải ảnh
                  return Container(
                    width: width,
                    height: height,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Không thể tải ảnh',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Container(
                    width: width,
                    height: height,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Đang tải...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // Cấu hình cache
                memCacheWidth: 400,
                memCacheHeight: 400,
                maxWidthDiskCache: 800,
                maxHeightDiskCache: 800,
              ),
              // Hiển thị thông tin người gửi nếu có
              if (senderName != null || sentTime != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
                        bottomRight: borderRadius?.bottomRight ?? Radius.zero,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (senderName != null)
                          Text(
                            senderName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (sentTime != null)
                          Text(
                            DateTimeUtils.formatDateTime(sentTime!),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
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
    );
  }
}
