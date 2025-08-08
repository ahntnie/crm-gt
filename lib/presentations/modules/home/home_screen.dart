import 'package:crm_gt/presentations/modules/home/components/home_view.dart';
import 'package:crm_gt/presentations/modules/home/cubit/attachments/attachments_cubit.dart';
import 'package:crm_gt/presentations/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/presentations/modules/notifications/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..getInit(),
        ),
        BlocProvider(
          create: (context) => NotificationsCubit(),
        ),
        BlocProvider(
          create: (context) => AttachmentCubit(),
        ),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.listDir.isNotEmpty) {
            final currentDirId = state.currentDir?.id ?? state.listDir.first.id ?? '';
            final level = state.currentDir?.level ?? 0;
            if (currentDirId.isNotEmpty) {
              // print(
              //     'HomeScreen: Calling getUnreadNotification with ID: $currentDirId and level: $level');
              context.read<NotificationsCubit>().getUnreadNotification(currentDirId);
            }
            if (level == '2') {
              print(
                  'HomeScreen: Calling getListAttachMentsById with ID: $currentDirId and level: $level');
              context.read<AttachmentCubit>().getListAttachMentsById(currentDirId);
            }
          }
        },
        child: const HomeView(),
      ),
    );
  }
}
