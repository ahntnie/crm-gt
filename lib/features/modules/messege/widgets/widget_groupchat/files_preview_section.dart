import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/domains/entities/attachment/attachment_entities.dart';
import 'package:crm_gt/domains/entities/messege/messege_entities.dart';
import 'package:crm_gt/features/modules/home/widgets/file_card.dart';
import 'package:crm_gt/features/modules/messege/cubit/group_chat_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilesPreviewSection extends StatelessWidget {
  final List<MessegeEntities> messages;

  const FilesPreviewSection({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatDetailCubit, GroupChatDetailState>(
      builder: (context, state) {
        final files = context.read<GroupChatDetailCubit>().getSortedFiles();

        if (files.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Không có file đính kèm',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
          );
        }

        final showCount = files.length > 4 ? 4 : files.length;
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('File đính kèm',
                  onSeeAll: files.length > 4
                      ? () {
                          _showAllFilesDialog(context, files);
                        }
                      : null),
              const SizedBox(height: 18),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: showCount,
                itemBuilder: (context, index) {
                  final file = files[index];
                  final attach = AttachmentEntities(
                    id: file.id,
                    fileName: file.fileName,
                    fileUrl: file.fileUrl,
                    fileType: file.fileType,
                    uploadedAt: file.sentAt,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: FileCard(file: attach),
                  );
                },
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

  void _showAllFilesDialog(BuildContext context, List<MessegeEntities> files) {
    // Sắp xếp files theo ngày tháng, mới nhất lên trước
    final sortedFiles = List<MessegeEntities>.from(files)
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
                  'Tất cả file đính kèm',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedFiles.length,
                  itemBuilder: (context, index) {
                    final file = sortedFiles[index];
                    final attach = AttachmentEntities(
                      id: file.id,
                      fileName: file.fileName,
                      fileUrl: file.fileUrl,
                      fileType: file.fileType,
                      uploadedAt: file.sentAt,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: FileCard(file: attach),
                    );
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
