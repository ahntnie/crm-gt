import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:crm_gt/core/services/app_refresh_service.dart';
import 'package:crm_gt/domains/usecases/authentication/login_usecase.dart';
import 'package:crm_gt/features/routes.dart';
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
    _handleAppRefreshIfNeeded();
    _checkInternetConnection();
  }

  Future<void> _handleAppRefreshIfNeeded() async {
    // Kiểm tra nếu đây là refresh từ AppRefreshService
    if (AppRefreshService().needsRefresh) {
      debugPrint('SplashScreen: Handling app refresh - clearing caches');

      // Clear các cache và data cũ
      await _clearAppCaches();

      // Đánh dấu đã refresh
      AppRefreshService().markRefreshed();

      debugPrint('SplashScreen: App refresh completed');
    }
  }

  Future<void> _clearAppCaches() async {
    try {
      // Clear một số cache cụ thể (có thể mở rộng thêm)
      final keysToRemove = [
        'cached_data',
        'temp_data',
        'last_sync',
        'cached_messages',
        'cached_notifications',
        'ui_state',
        'scroll_position'
      ];

      for (String key in keysToRemove) {
        try {
          await AppSP.remove(key);
        } catch (e) {
          // Ignore nếu key không tồn tại
        }
      }

      // Có thể thêm clear cache khác nếu cần
      // await clearImageCache();
      // await clearNetworkCache();

      debugPrint('SplashScreen: App caches cleared successfully');
    } catch (e) {
      debugPrint('SplashScreen: Error clearing caches: $e');
    }
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showNoConnectionDialog();
    } else {
      _checkAuthAndNavigate();
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Không có kết nối"),
          content: const Text("Vui lòng kết nối internet để tiếp tục."),
          actions: <Widget>[
            TextButton(
              child: const Text("Thử lại"),
              onPressed: () {
                AppNavigator.pop();
                _checkInternetConnection();
              },
            ),
          ],
        );
      },
    );
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
