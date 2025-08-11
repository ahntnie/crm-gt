import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/features/modules/home/widgets/app_bar_bulder.dart';
import 'package:crm_gt/features/modules/home/widgets/body_builder.dart';
import 'package:crm_gt/features/modules/home/widgets/floating_action_button.dart';
import 'package:crm_gt/features/modules/notifications/notifications_cubit.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:crm_gt/widgets/swipe_back_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends BaseWidget {
  const HomeView({super.key});

  @override
  onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getInit();
      final currentDirId = context.read<HomeCubit>().state.currentDir?.id;
      context.read<NotificationsCubit>().getUnreadNotification(currentDirId ?? '');
      context.read<AttachmentCubit>().getListAttachMentsById(currentDirId ?? '');
    });
    return super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    return SwipeBackWrapper(
      onSwipeBack: () => _handleBackNavigation(context, cubit),
      child: Scaffold(
        backgroundColor: AppColors.mono0,
        appBar: buildAppBar(context, cubit),
        body: buildBody(context, cubit),
        floatingActionButton: cubit.state.userInfo?.role == 'admin'
            ? buildFloatingActionButton(context, cubit)
            : null,
      ),
    );
  }
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
