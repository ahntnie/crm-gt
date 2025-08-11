import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_state.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/features/modules/home/widgets/dir_card.dart';
import 'package:crm_gt/features/modules/home/widgets/file_card.dart';
import 'package:crm_gt/features/modules/home/widgets/progress_edit_dialog.dart';
import 'package:crm_gt/features/modules/home/widgets/progress_tracker_widget.dart';
import 'package:crm_gt/features/modules/notifications/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildBody(BuildContext context, HomeCubit cubit) {
  return BlocListener<NotificationsCubit, NotificationsState>(
    listener: (context, state) {
      if (state.error != null) {
        debugPrint('Notifications error:  [${state.error}');
      }
    },
    child: BlocBuilder<NotificationsCubit, NotificationsState>(
      buildWhen: (previous, current) => previous.unreadCount != current.unreadCount,
      builder: (context, notiState) {
        return BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.listDir != current.listDir ||
              previous.currentDir != current.currentDir ||
              previous.isLoading != current.isLoading,
          builder: (context, homeState) {
            final currentDir = homeState.currentDir;
            // Nếu là level 2: chỉ hiển thị attachments, hoặc empty state nếu không có attachment
            if (currentDir?.level == '2') {
              return BlocBuilder<AttachmentCubit, AttachmentState>(
                builder: (context, attachState) {
                  if (attachState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cempedak101,
                      ),
                    );
                  }
                  if (attachState.listAttachments.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<AttachmentCubit>()
                          .getListAttachMentsById(currentDir?.id ?? '');
                    },
                    color: AppColors.cempedak101,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'Danh sách file đính kèm:',
                              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              // ),
                              const SizedBox(height: 8),
                              ...attachState.listAttachments.map((file) => FileCard(
                                    file: file,
                                    onTap: () {
                                      // TODO: Xử lý mở file hoặc tải file
                                    },
                                  )),
                            ],
                          ),
                        ),
                        if (_shouldShowProgressTracker(homeState))
                          _buildProgressTracker(context, cubit, homeState),
                      ],
                    ),
                  );
                },
              );
            }
            // Ngược lại: render listDir như cũ, không bao giờ hiện _buildEmptyState
            if (homeState.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.cempedak101,
                ),
              );
            }
            return Column(
              children: [
                if (_shouldShowProgressTracker(homeState))
                  _buildProgressTracker(context, cubit, homeState),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (currentDir == null) {
                        await cubit.getDirByLevel('0');
                      } else {
                        await cubit.getDirByParentId(currentDir.id ?? '');
                      }
                      for (var dir in cubit.state.listDir) {
                        if (dir.id != null) {
                          context.read<NotificationsCubit>().getUnreadNotification(dir.id!);
                        }
                      }
                    },
                    color: AppColors.cempedak101,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: homeState.listDir.length,
                      itemBuilder: (context, index) {
                        final dir = homeState.listDir[index];
                        final unreadCount = notiState.unreadCount[dir.id] ?? 0;
                        return DirCard(
                          dirEntities: dir,
                          onTap: () => _handleDirCardTap(context, cubit, dir),
                          unreadCount: unreadCount,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}

bool _shouldShowProgressTracker(HomeState state) {
  return state.currentDir?.level == '2' && state.currentDir?.name?.toLowerCase() == 'tiến độ';
}

bool _canEditProgress(HomeState state) {
  final userRole = state.userInfo?.role;
  final isCreator = state.currentDir?.createdBy == state.userInfo?.id;
  return isCreator || userRole == 'admin' || userRole == 'manager';
}

Widget _buildProgressTracker(BuildContext context, HomeCubit cubit, HomeState state) {
  final mockProgress = 45;
  final mockMilestones = [
    const ProgressMilestone(
      title: 'Khởi tạo dự án',
      description: 'Thiết lập môi trường và team',
      percentage: 10,
    ),
    const ProgressMilestone(
      title: 'Phân tích yêu cầu',
      description: 'Thu thập và phân tích requirements',
      percentage: 25,
    ),
    const ProgressMilestone(
      title: 'Thiết kế hệ thống',
      description: 'Thiết kế architecture và UI/UX',
      percentage: 40,
    ),
    const ProgressMilestone(
      title: 'Phát triển tính năng',
      description: 'Implement các tính năng chính',
      percentage: 70,
    ),
    const ProgressMilestone(
      title: 'Testing & QA',
      description: 'Kiểm thử và đảm bảo chất lượng',
      percentage: 90,
    ),
    const ProgressMilestone(
      title: 'Triển khai',
      description: 'Deploy và go-live',
      percentage: 100,
    ),
  ];

  return ProgressTrackerWidget(
    currentProgress: mockProgress,
    projectName: state.currentDir?.name ?? 'Dự án',
    canEdit: _canEditProgress(state),
    milestones: mockMilestones,
    onEditPressed: () => _showProgressEditDialog(
      context,
      cubit,
      mockProgress,
      mockMilestones,
    ),
  );
}

void _showProgressEditDialog(
  BuildContext context,
  HomeCubit cubit,
  int currentProgress,
  List<ProgressMilestone> milestones,
) {
  showDialog(
    context: context,
    builder: (context) => ProgressEditDialog(
      currentProgress: currentProgress,
      milestones: milestones,
      onSave: (progress, updatedMilestones) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật tiến độ thành công!'),
            backgroundColor: AppColors.cempedak101,
          ),
        );
      },
    ),
  );
}

Widget _buildEmptyState(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_open,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'Chưa có thư mục nào',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Nhấn nút + để tạo thư mục mới',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    ),
  );
}

Future<void> _handleRefresh(BuildContext context, HomeCubit cubit) async {
  try {
    if (cubit.state.currentDir == null) {
      await cubit.getDirByLevel('0');
    } else {
      await cubit.getDirByParentId(cubit.state.currentDir!.id.toString());
    }
    for (var dir in cubit.state.listDir) {
      if (dir.id != null) {
        context.read<NotificationsCubit>().getUnreadNotification(dir.id!);
      }
    }
  } catch (e) {
    debugPrint('Error in refresh: $e');
  }
}

Future<void> _handleDirCardTap(BuildContext context, HomeCubit cubit, dir) async {
  if (dir.id == null) {
    debugPrint('DirCard onTap: Invalid dir.id');
    return;
  }
  try {
    debugPrint('DirCard onTap: dir.id=${dir.id}, name=${dir.name}');
    cubit.changeCurrentDir(dir);
    await cubit.getDirByParentId(dir.id!);
    for (var childDir in cubit.state.listDir) {
      if (childDir.id != null) {
        debugPrint('Fetching unreadCount for childDir.id=${childDir.id}');
        context.read<NotificationsCubit>().getUnreadNotification(childDir.id!);
      }
    }
  } catch (e) {
    debugPrint('Error in dir card tap: $e');
  }
}
