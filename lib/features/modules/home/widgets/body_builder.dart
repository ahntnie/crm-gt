import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_state.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/features/modules/home/widgets/dir_card.dart';
import 'package:crm_gt/features/modules/home/widgets/file_card.dart';
import 'package:crm_gt/features/modules/home/widgets/progress_section.dart';
import 'package:crm_gt/features/modules/notifications/notifications_cubit.dart';
import 'package:crm_gt/features/routes.dart';
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
            if (currentDir?.level == '2') {
              // Hiển thị Progress nếu type là 'progress'
              if (currentDir?.type == 'progress') {
                return RefreshIndicator(
                  onRefresh: () async {
                    // Refresh logic for progress
                  },
                  color: app.AppColors.cempedak101,
                  child: ListView(
                    children: [
                      ProgressSection(dirId: currentDir?.id ?? ''),
                    ],
                  ),
                );
              }

              // Hiển thị Attachments cho các type khác
              return BlocBuilder<AttachmentCubit, AttachmentState>(
                builder: (context, attachState) {
                  if (attachState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: app.AppColors.cempedak101,
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
                    color: app.AppColors.cempedak101,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              ...attachState.listAttachments.map((file) => FileCard(
                                    file: file,
                                    onTap: () {},
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            if (homeState.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: app.AppColors.cempedak101,
                ),
              );
            }
            return Column(
              children: [
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
                    color: app.AppColors.cempedak101,
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

Future<void> _handleDirCardTap(BuildContext context, HomeCubit cubit, dir) async {
  if (dir.id == null) {
    debugPrint('DirCard onTap: Invalid dir.id');
    return;
  }
  try {
    debugPrint(
        'DirCard onTap: dir.id=${dir.id}, name=${dir.name}, level=${dir.level}, type=${dir.type}');

    // Nếu là level 2 và type là 'progress', navigate trực tiếp đến Progress screen
    if (dir.level == '2' && dir.type == 'progress') {
      AppNavigator.push(Routes.progress, dir.id!);
      return;
    }

    // Logic navigation bình thường cho các trường hợp khác
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
