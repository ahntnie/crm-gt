import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/authentication/profile/cubit/profile_cubit.dart';
import 'package:crm_gt/features/modules/authentication/profile/cubit/profile_state.dart';
import 'package:crm_gt/features/modules/authentication/profile/widgets/logout_dialog.dart';
import 'package:crm_gt/features/modules/authentication/profile/widgets/profile_option.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getCurrentUser(); // Gọi luôn để đảm bảo dữ liệu mới nhất
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.cempedak101,
        title: const Text(
          'Hồ sơ',
          style: TextStyle(
            color: AppColors.mono0,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: buildProfileBody(context),
    );
  }
}

Widget buildProfileBody(BuildContext context) {
  return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, state) {
      final userInfo = state.userInfo;
      if (userInfo == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        color: AppColors.cempedak101,
        onRefresh: () => context.read<ProfileCubit>().getCurrentUser(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Profile Information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.mono0,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tên',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.userInfo!.name ?? 'Chưa cập nhật',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Số điện thoại',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: AppColors.cempedak101,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userInfo.phone ?? 'Không có số điện thoại',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Profile Options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mono0,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildProfileOption(
                      icon: Icons.edit,
                      title: 'Chỉnh sửa thông tin',
                      subtitle: 'Cập nhật thông tin cá nhân',
                      onTap: () {
                        AppNavigator.pushNamed(Routes.changeUsername.path);
                      },
                    ),
                    _buildDivider(),
                    buildProfileOption(
                      icon: Icons.security,
                      title: 'Bảo mật',
                      subtitle: 'Đổi mật khẩu, bảo mật tài khoản',
                      onTap: () {
                        AppNavigator.pushNamed(Routes.changePassword.path);
                      },
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cempedak101,
                    foregroundColor: AppColors.mono0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDivider() {
  return Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[200],
    indent: 70,
  );
}
