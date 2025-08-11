import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/data/models/request/attachments/attachment_request.dart';
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/features/modules/home/widgets/dialog_utils.dart';
import 'package:crm_gt/features/modules/notifications/notifications_cubit.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PreferredSizeWidget buildAppBar(BuildContext context, HomeCubit cubit) {
  return AppBar(
    elevation: 0,
    backgroundColor: AppColors.cempedak101,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    leading: cubit.state.currentDir != null
        ? IconButton(
            onPressed: () => _handleBackNavigation(context, cubit),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mono0),
            tooltip: 'Quay lại',
          )
        : null,
    centerTitle: true,
    title: Text(
      _getAppBarTitle(cubit),
      style: const TextStyle(
        color: AppColors.mono0,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    actions: _buildAppBarActions(context, cubit),
  );
}

String _getAppBarTitle(HomeCubit cubit) {
  if (cubit.state.currentDir == null) {
    return 'CRM GT';
  }
  if (cubit.state.currentDir!.level == '1') {
    return '${cubit.state.currentDir!.parentName ?? ''} > ${cubit.state.currentDir!.name!}';
  }
  return cubit.state.currentDir!.name!;
}

List<Widget> _buildAppBarActions(BuildContext context, HomeCubit cubit) {
  final actions = <Widget>[];
  if (cubit.state.currentDir?.level == null) {
    actions.addAll([
      IconButton(
        onPressed: () => AppNavigator.pushNamed(Routes.notificationDebug.path),
        icon: const Icon(Icons.bug_report, color: AppColors.mono0),
        tooltip: 'Debug Notification',
      ),
      IconButton(
        onPressed: () => AppNavigator.pushNamed(Routes.profile.path),
        icon: const Icon(Icons.person, color: AppColors.mono0),
        tooltip: 'Hồ sơ',
      ),
    ]);
  }
  if (cubit.state.currentDir?.level == '2' &&
      cubit.state.currentDir?.name?.toLowerCase() != 'tiến độ') {
    actions.add(
      IconButton(
        onPressed: () => handleUploadFiles(context, cubit),
        icon: const Icon(Icons.add, color: AppColors.mono0),
        tooltip: 'Thêm tài liệu',
      ),
    );
  }
  if (cubit.state.currentDir?.level == '1') {
    actions.addAll([
      if (cubit.state.userInfo?.role == 'admin')
        IconButton(
          onPressed: () => showAddMemberDialog(context),
          icon: const Icon(Icons.person_add, color: AppColors.mono0),
          tooltip: 'Thêm thành viên',
        ),
      _buildMessageButton(context, cubit),
    ]);
  }
  return actions;
}

Widget _buildMessageButton(BuildContext context, HomeCubit cubit) {
  return BlocBuilder<NotificationsCubit, NotificationsState>(
    buildWhen: (previous, current) => previous.unreadCount != current.unreadCount,
    builder: (context, state) {
      final threadId = cubit.state.currentDir?.id ?? '';
      final unreadCount = state.unreadCount[threadId] ?? 0;
      return Stack(
        children: [
          IconButton(
            onPressed: () {
              AppNavigator.pushNamed(Routes.messege.path, threadId);
              context.read<NotificationsCubit>().resetUnread(threadId);
            },
            icon: const Icon(Icons.message, color: AppColors.mono0),
            tooltip: 'Tin nhắn',
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount > 9 ? '9+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: AppColors.mono0,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    },
  );
}

Future<void> _handleBackNavigation(BuildContext context, HomeCubit cubit) async {
  try {
    await cubit.getCurrentDir(cubit.state.currentDir?.parentId);
    if (cubit.state.currentDir?.id == null) {
      cubit.getDirByLevel('0');
      final firstDirId = cubit.state.listDir.isNotEmpty ? cubit.state.listDir.first.id : null;
      if (firstDirId != null) {
        context.read<NotificationsCubit>().getUnreadNotification(firstDirId);
      }
    } else {
      cubit.getDirByParentId(cubit.state.currentDir!.id!);
      for (var dir in cubit.state.listDir) {
        if (dir.id != null) {
          context.read<NotificationsCubit>().getUnreadNotification(dir.id!);
        }
      }
    }
  } catch (e) {
    debugPrint('Error in back navigation: $e');
  }
}

Future<void> handleUploadFiles(BuildContext context, HomeCubit cubit) async {
  final currentDirId = cubit.state.currentDir?.id;
  if (currentDirId == null) return;
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null && result.files.isNotEmpty) {
    final files = result.files;
    final List<String> filePaths = [];
    for (final file in files) {
      if (file.path != null) {
        filePaths.add(file.path!);
      }
    }
    if (filePaths.isEmpty) return;
    final attachmentCubit = context.read<AttachmentCubit>();
    final request = AttachmentRequest(
      threadId: currentDirId,
      files: filePaths,
    );
    await attachmentCubit.uploadAttactments(request);
    // Sau khi upload xong, reload lại danh sách file đính kèm
    await attachmentCubit.getListAttachMentsById(currentDirId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tải lên thành công!')),
    );
  }
}
