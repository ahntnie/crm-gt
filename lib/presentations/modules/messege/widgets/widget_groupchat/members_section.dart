import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';
import 'package:flutter/material.dart';

class MembersSection extends StatelessWidget {
  final List<UserEntities> users;

  const MembersSection({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    final showCount = users.length > 3 ? 3 : users.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Thành viên nhóm',
            onSeeAll: users.length > 3
                ? () {
                    _showAllMembersDialog(context);
                  }
                : null),
        const SizedBox(height: 18),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: showCount,
          itemBuilder: (context, index) {
            final user = users[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mono0,
                        AppColors.cempedak101.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cempedak101.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.cempedak101.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        color: AppColors.cempedak101,
                        size: 32,
                      ),
                    ),
                    title: Text(
                      user.name ?? 'Không tên',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'SĐT: ${user.phone ?? '---'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (user.role != null && user.role!.trim().isNotEmpty)
                          Text(
                            'Vai trò: ${user.role}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => _showUserInfoDialog(context, user),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: AppColors.cempedak101,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (users.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Center(
              child: TextButton(
                onPressed: () => _showAllMembersDialog(context),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.cempedak101.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Xem tất cả ${users.length} thành viên',
                  style: const TextStyle(
                    color: AppColors.cempedak101,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: AppColors.cempedak101,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAllMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: AppColors.mono0,
        child: Container(
          width: 360,
          height: 520,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.cempedak101.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Text(
                  'Tất cả thành viên',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.mono0,
                                AppColors.cempedak101.withOpacity(0.03),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.cempedak101.withOpacity(0.15),
                              child: Icon(
                                Icons.person,
                                color: AppColors.cempedak101,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              user.name ?? 'Không tên',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'SĐT: ${user.phone ?? '---'}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (user.role != null && user.role!.trim().isNotEmpty)
                                  Text(
                                    'Vai trò: ${user.role}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              _showUserInfoDialog(context, user);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cempedak101,
                    foregroundColor: AppColors.mono0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserInfoDialog(BuildContext context, UserEntities user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: AppColors.mono0,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        title: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.cempedak101.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            user.name ?? 'Thông tin thành viên',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'SĐT',
              value: user.phone ?? '---',
            ),
            if (user.role != null && user.role!.trim().isNotEmpty)
              _buildInfoRow(
                icon: Icons.badge,
                label: 'Vai trò',
                value: user.role!,
              ),
            if (user.userName != null && user.userName!.trim().isNotEmpty)
              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Username',
                value: user.userName!,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: AppColors.cempedak101.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Đóng',
              style: TextStyle(
                color: AppColors.cempedak101,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.cempedak101,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
