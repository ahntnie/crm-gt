import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/cubit/profile_cubit.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/cubit/profile_state.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeUsernameView extends StatefulWidget {
  const ChangeUsernameView({super.key});

  @override
  State<ChangeUsernameView> createState() => _ChangeUsernameViewState();
}

class _ChangeUsernameViewState extends State<ChangeUsernameView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.cempedak101,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          // Đợi getCurrentUser hoàn thành trước khi pop
          await context.read<ProfileCubit>().getCurrentUser();
          if (context.mounted) {
            AppNavigator.pop();
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: _buildAppBar(context),
          body: _buildBody(cubit, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.cempedak101,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        onPressed: () {
          AppNavigator.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mono0),
      ),
      title: const Text(
        'Đổi tên người dùng',
        style: TextStyle(
          color: AppColors.mono0,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(ProfileCubit cubit, ProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildUsernameForm(cubit, state),
            const SizedBox(height: 24),
            _buildChangeUsernameButton(cubit, state),
            const SizedBox(height: 24),
            _buildUsernameRules(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mono0,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.cempedak101,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cập nhật tên người dùng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tạo tên người dùng mới cho hồ sơ của bạn',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameForm(ProfileCubit cubit, ProfileState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mono0,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentUsernameField(state),
          const SizedBox(height: 16),
          _buildNewUsernameField(cubit, state),
          const SizedBox(height: 16),
          _buildPasswordField(cubit, state),
        ],
      ),
    );
  }

  Widget _buildCurrentUsernameField(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên người dùng hiện tại',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: TextEditingController(text: state.userInfo?.name ?? 'Chưa có tên người dùng'),
          enabled: false,
          style: const TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person, color: Colors.grey, size: 20),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildNewUsernameField(ProfileCubit cubit, ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên người dùng mới',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: cubit.usernameController,
          onChanged: cubit.usernameChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tên người dùng mới';
            }
            if (value.length < 3 || value.length > 20) {
              return 'Tên người dùng phải từ 3-20 ký tự';
            }

            if (value == state.userInfo?.name) {
              return 'Tên người dùng mới phải khác tên hiện tại';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Nhập tên người dùng mới',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.person_add, color: AppColors.cempedak101, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cempedak101, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField(ProfileCubit cubit, ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mật khẩu xác nhận',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: cubit.passwordController,
          onChanged: cubit.passwordChanged,
          obscureText: !state.isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập mật khẩu';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Nhập mật khẩu',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.cempedak101, size: 20),
            suffixIcon: IconButton(
              onPressed: cubit.togglePasswordVisibility,
              icon: Icon(
                state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cempedak101, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            if (_formKey.currentState!.validate()) {
              cubit.changeUsername();
            }
          },
        ),
      ],
    );
  }

  Widget _buildChangeUsernameButton(ProfileCubit cubit, ProfileState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  cubit.changeUsername();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cempedak101,
          foregroundColor: AppColors.mono0,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBackgroundColor: AppColors.cempedak101.withOpacity(0.5),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.mono0,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Cập nhật',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildUsernameRules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Quy tắc tên người dùng',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildUsernameRule('Từ 3-20 ký tự'),
          _buildUsernameRule('Chỉ sử dụng chữ cái, số và dấu gạch dưới (_)'),
          _buildUsernameRule('Bắt đầu bằng chữ cái'),
          _buildUsernameRule('Không chứa khoảng trắng'),
          _buildUsernameRule('Phải là duy nhất trong hệ thống'),
        ],
      ),
    );
  }

  Widget _buildUsernameRule(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.orange[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
