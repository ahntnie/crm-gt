import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/authentication/profile/cubit/profile_cubit.dart';
import 'package:crm_gt/features/modules/authentication/profile/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
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
          // Không cần gọi getCurrentUser vì userInfo đã được cập nhật trong changePassword
          // Navigator.of(context).pop(); // Tùy chọn: quay lại màn hình trước sau khi đổi thành công
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
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mono0),
      ),
      title: const Text(
        'Đổi mật khẩu',
        style: TextStyle(
          color: AppColors.mono0,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(ProfileCubit cubit, ProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildPasswordForm(cubit, state),
            const SizedBox(height: 32),
            _buildChangePasswordButton(cubit, state),
            const SizedBox(height: 24),
            _buildSecurityTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mono0,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.security,
              color: AppColors.cempedak101,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bảo mật tài khoản',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Thay đổi mật khẩu để bảo vệ tài khoản của bạn',
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

  Widget _buildPasswordForm(ProfileCubit cubit, ProfileState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mono0,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPasswordField(
            state: state,
            cubit: cubit,
            controller: cubit.currentPasswordController,
            label: 'Mật khẩu hiện tại',
            hint: 'Nhập mật khẩu hiện tại',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu hiện tại';
              }
              return null;
            },
            obscureText: !state.isCurrentPasswordVisible,
            onChanged: cubit.currentPasswordChanged,
            toggleVisibility: cubit.toggleCurrentPasswordVisibility,
          ),
          const SizedBox(height: 20),
          _buildPasswordField(
            state: state,
            cubit: cubit,
            controller: cubit.newPasswordController,
            label: 'Mật khẩu mới',
            hint: 'Nhập mật khẩu mới',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu mới';
              }
              if (value.length < 8) {
                return 'Mật khẩu mới phải có ít nhất 8 ký tự';
              }
              return null;
            },
            obscureText: !state.isNewPasswordVisible,
            onChanged: cubit.newPasswordChanged,
            toggleVisibility: cubit.toggleNewPasswordVisibility,
          ),
          const SizedBox(height: 20),
          _buildPasswordField(
            state: state,
            cubit: cubit,
            controller: cubit.confirmPasswordController,
            label: 'Xác nhận mật khẩu mới',
            hint: 'Nhập lại mật khẩu mới',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu mới';
              }
              if (value != cubit.newPasswordController.text) {
                return 'Mật khẩu xác nhận không khớp';
              }
              return null;
            },
            obscureText: !state.isConfirmPasswordVisible,
            onChanged: cubit.confirmPasswordChanged,
            toggleVisibility: cubit.toggleConfirmPasswordVisibility,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required ProfileState state,
    required ProfileCubit cubit,
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required bool obscureText,
    required void Function(String) onChanged,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cempedak101.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: AppColors.cempedak101,
                size: 20,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: toggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.cempedak101,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red[400]!,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red[400]!,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton(ProfileCubit cubit, ProfileState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isChangePasswordLoading || !state.isFormValid
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  cubit.changePassword();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cempedak101,
          foregroundColor: AppColors.mono0,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isChangePasswordLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.mono0,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Đổi mật khẩu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Lời khuyên bảo mật',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSecurityTip('Sử dụng mật khẩu có ít nhất 8 ký tự'),
          _buildSecurityTip('Kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt'),
          _buildSecurityTip('Không sử dụng thông tin cá nhân dễ đoán'),
          _buildSecurityTip('Thay đổi mật khẩu định kỳ'),
        ],
      ),
    );
  }

  Widget _buildSecurityTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
