import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/features/modules/progress/cubit/progress_cubit.dart';
import 'package:crm_gt/features/modules/progress/widgets/create_progress_dialog.dart';
import 'package:crm_gt/features/modules/progress/widgets/progress_card.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressView extends BaseWidget {
  final String dirId;

  const ProgressView({
    super.key,
    required this.dirId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgressCubit, ProgressState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
          print('Error: ${state.error}');
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
      child: Scaffold(
          backgroundColor: app.AppColors.mono0,
          appBar: AppBar(
            backgroundColor: app.AppColors.cempedak101,
            title: Text(
              'Tiến độ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          body: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<ProgressCubit>().loadProgressByDirId(dirId),
                child: state.progressList.isEmpty
                    ? _buildEmptyState(context)
                    : _buildProgressList(context, state),
              );
            },
          ),
          floatingActionButton: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, state) {
              // Chỉ hiển thị nút thêm cho admin
              if (!state.isAdmin) return const SizedBox.shrink();

              return FloatingActionButton.extended(
                backgroundColor: app.AppColors.cempedak101,
                foregroundColor: app.AppColors.mono0,
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Thêm tiến độ'),
                elevation: 4,
              );
            },
          )),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Chưa có tiến độ nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Nhấn nút + để tạo tiến độ mới',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressList(BuildContext context, ProgressState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.progressList.length,
      physics: const AlwaysScrollableScrollPhysics(), // For RefreshIndicator
      itemBuilder: (context, index) {
        final progress = state.progressList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, progressState) {
              return ProgressCard(
                key: ValueKey(progress.id), // Add key for better performance
                progress: progress,
                isAdmin: progressState.isAdmin, // Pass admin status
                onPercentageChanged: (percentage) {
                  context.read<ProgressCubit>().updateProgressPercentage(
                        progress.id!,
                        percentage.toString(),
                      );
                },
              );
            },
          ),
        );
      },
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
