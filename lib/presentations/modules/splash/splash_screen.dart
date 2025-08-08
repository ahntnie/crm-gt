import 'dart:async';

import 'package:core/core.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final token = await AppSecureStorage.getToken();
    if (token?.accessToken != null && token!.accessToken!.isNotEmpty) {
      // Xác thực token với backend
      try {
        final loginUseCase = getIt.get<LoginUsecase>();
        final isValid = await loginUseCase.checkTokenLogin();
        if (isValid) {
          if (mounted) AppNavigator.go(Routes.home);
          return;
        } else {
          // Token không hợp lệ, xóa local
          await AppSecureStorage.clearToken();
          await AppSP.remove('account');
          await AppSP.remove('user_info');
        }
      } catch (_) {
        // Lỗi network hoặc server, xóa token để đảm bảo bảo mật
        await AppSecureStorage.clearToken();
        await AppSP.remove('account');
        await AppSP.remove('user_info');
      }
    }
    if (mounted) AppNavigator.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE86C16), // #e86c16 từ pubspec.yaml
      body: Center(
        child: Image.asset(
          'assets/images/ic_logo.jpg', // Đúng đường dẫn pubspec.yaml
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
