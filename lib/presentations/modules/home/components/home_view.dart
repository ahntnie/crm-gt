import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/presentations/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/presentations/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/presentations/modules/home/widgets/app_bar_bulder.dart';
import 'package:crm_gt/presentations/modules/home/widgets/body_builder.dart';
import 'package:crm_gt/presentations/modules/home/widgets/floating_action_button.dart';
import 'package:crm_gt/presentations/modules/notifications/notifications_cubit.dart';
import 'package:crm_gt/widgets/base_widget.dart';
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
    return Scaffold(
      backgroundColor: AppColors.mono0,
      appBar: buildAppBar(context, cubit),
      body: buildBody(context, cubit),
      floatingActionButton:
          cubit.state.userInfo?.role == 'admin' ? buildFloatingActionButton(context, cubit) : null,
    );
  }
}
