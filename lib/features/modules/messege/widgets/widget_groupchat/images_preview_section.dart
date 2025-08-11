import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/domains/entities/messege/messege_entities.dart';
import 'package:crm_gt/features/modules/messege/cubit/group_chat_detail_cubit.dart';
import 'package:crm_gt/features/modules/messege/widgets/image_screen_item.dart';
import 'package:crm_gt/features/modules/messege/widgets/widget_groupchat/optimized_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagesPreviewSection extends StatelessWidget {
  final List<MessegeEntities> messages;

  const ImagesPreviewSection({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatDetailCubit, GroupChatDetailState>(
      builder: (context, state) {
        final images = context.read<GroupChatDetailCubit>().getSortedImages();

        if (images.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Không có hình ảnh/video đính kèm',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
          );
        }

        final showCount = images.length > 6 ? 6 : images.length;
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Hình ảnh/Video đính kèm',
                  onSeeAll: images.length > 6
                      ? () {
                          _showAllImagesDialog(context, images);
                        }
                      : null),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildImageGrid(images.take(showCount).toList()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: AppColors.cempedak101,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<MessegeEntities> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return _buildSingleImage(images[0]);
    } else if (images.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildSingleImage(images[0])),
          const SizedBox(width: 8),
          Expanded(child: _buildSingleImage(images[1])),
        ],
      );
    } else if (images.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildSingleImage(images[0]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildSingleImage(images[1])),
                const SizedBox(height: 8),
                Expanded(child: _buildSingleImage(images[2])),
              ],
            ),
          ),
        ],
      );
    } else if (images.length == 4) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSingleImage(images[0])),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleImage(images[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSingleImage(images[2])),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleImage(images[3])),
            ],
          ),
        ],
      );
    } else {
      // 5-6 images
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSingleImage(images[0])),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleImage(images[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSingleImage(images[2])),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleImage(images[3])),
            ],
          ),
          if (images.length > 4) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildSingleImage(images[4])),
                if (images.length > 5) ...[
                  const SizedBox(width: 8),
                  Expanded(child: _buildSingleImage(images[5])),
                ],
              ],
            ),
          ],
        ],
      );
    }
  }

  Widget _buildSingleImage(MessegeEntities image) {
    return Builder(
      builder: (context) => OptimizedImageWidget(
        imageUrl: image.fileUrl!,
        height: 120,
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenImageViewer(imageUrl: image.fileUrl!),
            ),
          );
        },
      ),
    );
  }

  void _showAllImagesDialog(BuildContext context, List<MessegeEntities> images) {
    // Sắp xếp images theo ngày tháng, mới nhất lên trước
    final sortedImages = List<MessegeEntities>.from(images)
      ..sort((a, b) {
        final dateA = a.sentAt != null ? DateTime.tryParse(a.sentAt!) : null;
        final dateB = b.sentAt != null ? DateTime.tryParse(b.sentAt!) : null;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA); // Mới nhất lên trước
      });

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: 350,
          height: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Tất cả hình ảnh/video đính kèm',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: sortedImages.length,
                  itemBuilder: (context, index) {
                    final image = sortedImages[index];
                    return _buildSingleImage(image);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cempedak101,
                    foregroundColor: AppColors.mono0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
