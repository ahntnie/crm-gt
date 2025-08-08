import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:crm_gt/presentations/modules/messege/cubit/group_chat_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupInfoCard extends StatelessWidget {
  final String groupName;
  final List<UserEntities> users;

  const GroupInfoCard({
    super.key,
    required this.groupName,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatDetailCubit, GroupChatDetailState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.mono0,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.cempedak101.withOpacity(0.1),
                child: Icon(
                  Icons.group,
                  size: 56,
                  color: AppColors.cempedak101,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                groupName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '${users.length} thành viên',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.notifications_off_outlined,
                    label: 'Tắt thông báo',
                    isLoading: state.isLoading,
                    onTap: () {
                      context.read<GroupChatDetailCubit>().toggleNotification();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.cempedak101,
                      ),
                    ),
                  )
                : Icon(icon, color: AppColors.cempedak101, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isLoading ? Colors.grey[400] : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
