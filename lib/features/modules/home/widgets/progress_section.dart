import 'package:crm_gt/features/modules/progress/cubit/progress_cubit.dart';
import 'package:crm_gt/features/modules/progress/widgets/create_progress_dialog.dart';
import 'package:crm_gt/features/modules/progress/widgets/progress_card.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressSection extends StatelessWidget {
  final String dirId;

  const ProgressSection({
    super.key,
    required this.dirId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressCubit()..loadProgressByDirId(dirId),
      child: BlocListener<ProgressCubit, ProgressState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<ProgressCubit>().clearError();
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ProgressCubit>().clearSuccessMessage();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với nút thêm và xem tất cả
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tiến độ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm'),
                  ),
                  TextButton(
                    onPressed: () => AppNavigator.push(Routes.progress, dirId),
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),

            // Progress List
            BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.progressList.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.track_changes,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chưa có tiến độ nào',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nhấn "Thêm" để tạo tiến độ mới',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Hiển thị tối đa 3 progress gần nhất
                final displayList = state.progressList.take(3).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...displayList.map((progress) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProgressCard(
                            progress: progress,
                            isAdmin: state.isAdmin, // Pass admin status
                            onPercentageChanged: (percentage) {
                              context.read<ProgressCubit>().updateProgressPercentage(
                                    progress.id!,
                                    percentage.toString(),
                                  );
                            },
                          ),
                        );
                      }),
                      if (state.progressList.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextButton(
                            onPressed: () => AppNavigator.push(Routes.progress, dirId),
                            child: Text('Xem thêm ${state.progressList.length - 3} tiến độ khác'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProgressCubit>(),
        child: CreateProgressDialog(dirId: dirId),
      ),
    );
  }
}
