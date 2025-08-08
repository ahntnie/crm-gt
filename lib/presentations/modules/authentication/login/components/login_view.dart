import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/presentations/modules/authentication/login/widgets/password_field.dart';
import 'package:crm_gt/presentations/modules/authentication/login/widgets/username_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi checkTokenLogin khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().checkTokenLogin();
    });

    return Scaffold(
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cempedak90,
                  AppColors.cempedak101,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo và welcome text
                      _buildHeader(),
                      const SizedBox(height: 40),

                      // Login form card
                      _buildLoginCard(context, state),

                      const SizedBox(height: 24),

                      // Footer text
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo container
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.mono0.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.business_center,
            size: 50,
            color: AppColors.mono0,
          ),
        ),
        const SizedBox(height: 24),

        // Welcome text
        const Text(
          'Chào mừng trở lại!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.mono0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Đăng nhập để tiếp tục sử dụng CRM GT',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.mono0.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context, LoginState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mono0,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form title
            const Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Username field
            const UserNameField(),
            const SizedBox(height: 20),

            // Password field
            const PasswordField(),
            const SizedBox(height: 32),

            // Login button
            _buildLoginButton(context, state),

            // Error message
            if (state.error != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(state.error!),
            ],

            const SizedBox(height: 24),

            // Forgot password
            _buildSignIn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cempedak101, AppColors.cempedak90],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cempedak101.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: state.isLoading ? null : () => context.read<LoginCubit>().onTapLogin(),
          child: Container(
            alignment: Alignment.center,
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.mono0,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mono0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final Uri url = Uri.parse('https://gtglobal.com.vn/signin-crm');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.inAppWebView);
        } else {
          // Handle error if URL cannot be launched
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không thể mở liên kết'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: const Text(
        'Đăng ký tài khoản',
        style: TextStyle(
          color: AppColors.rambutan100,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      '© 2025 GT GLOBAL. All rights reserved.',
      style: TextStyle(
        color: AppColors.mono0.withOpacity(0.7),
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
