import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/domains/entities/messege/messege_entities.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/presentations/modules/messege/cubit/group_chat_detail_cubit.dart';
import 'package:crm_gt/presentations/modules/messege/widgets/widget_groupchat/files_preview_section.dart';
import 'package:crm_gt/presentations/modules/messege/widgets/widget_groupchat/group_info_card.dart';
import 'package:crm_gt/presentations/modules/messege/widgets/widget_groupchat/images_preview_section.dart';
import 'package:crm_gt/presentations/modules/messege/widgets/widget_groupchat/members_section.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupChatDetailScreen extends StatelessWidget {
  final List<UserEntities> users;
  final List<MessegeEntities> messages;
  final String groupName;

  const GroupChatDetailScreen({
    super.key,
    required this.users,
    required this.messages,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupChatDetailCubit(
        users: users,
        messages: messages,
        groupName: groupName,
      ),
      child: BlocListener<GroupChatDetailCubit, GroupChatDetailState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<GroupChatDetailCubit>().clearError();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.mono0,
          appBar: AppBar(
            backgroundColor: AppColors.cempedak101,
            elevation: 0,
            leading: IconButton(
              onPressed: () => AppNavigator.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.mono0,
              ),
            ),
            title: Text(
              'Chi tiết nhóm',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mono0,
                  ),
            ),
            centerTitle: true,
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: const SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: GroupInfoCard(
                  groupName: groupName,
                  users: users,
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 32)),
              SliverToBoxAdapter(child: MembersSection(users: users)),
              SliverToBoxAdapter(child: const SizedBox(height: 32)),
              ImagesPreviewSection(messages: messages),
              SliverToBoxAdapter(child: const SizedBox(height: 32)),
              FilesPreviewSection(messages: messages),
              SliverToBoxAdapter(child: const SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
