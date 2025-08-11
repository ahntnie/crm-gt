import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Service để quản lý refresh app khi người dùng quay lại sau thời gian dài
class AppRefreshService {
  static final AppRefreshService _instance = AppRefreshService._internal();
  factory AppRefreshService() => _instance;
  AppRefreshService._internal();

  // Thời gian tối đa app có thể ở background trước khi refresh (milliseconds)
  static const int _maxInactiveTime = 5 * 60 * 1000; // 5 phút

  // Thời gian app vào background
  DateTime? _backgroundTime;

  // Callback khi cần refresh app
  VoidCallback? _onRefreshNeeded;

  // Trạng thái hiện tại
  bool _isInBackground = false;
  bool _needsRefresh = false;

  /// Đăng ký callback khi cần refresh
  void setRefreshCallback(VoidCallback callback) {
    _onRefreshNeeded = callback;
    debugPrint('AppRefreshService: Refresh callback registered');
  }

  /// Gọi khi app vào background
  void onAppPaused() {
    _backgroundTime = DateTime.now();
    _isInBackground = true;
    debugPrint('AppRefreshService: App paused at ${_backgroundTime.toString()}');
  }

  /// Gọi khi app quay lại foreground
  void onAppResumed() {
    if (_backgroundTime != null && _isInBackground) {
      final now = DateTime.now();
      final inactiveTime = now.difference(_backgroundTime!).inMilliseconds;

      debugPrint('AppRefreshService: App resumed after ${inactiveTime}ms inactive');
      debugPrint('AppRefreshService: Max inactive time: ${_maxInactiveTime}ms');

      if (inactiveTime >= _maxInactiveTime) {
        _needsRefresh = true;
        debugPrint('AppRefreshService: Refresh needed - inactive too long');

        // Trigger refresh callback
        if (_onRefreshNeeded != null) {
          debugPrint('AppRefreshService: Triggering refresh callback');
          _onRefreshNeeded!();
        }
      } else {
        debugPrint('AppRefreshService: No refresh needed - inactive time OK');
      }
    }

    _isInBackground = false;
    _backgroundTime = null;
  }

  /// Gọi khi app bị detached/terminated
  void onAppDetached() {
    debugPrint('AppRefreshService: App detached/terminated');
    _backgroundTime = null;
    _isInBackground = false;
    _needsRefresh = false;
  }

  /// Kiểm tra xem có cần refresh không
  bool get needsRefresh => _needsRefresh;

  /// Đánh dấu đã refresh xong
  void markRefreshed() {
    _needsRefresh = false;
    debugPrint('AppRefreshService: Marked as refreshed');
  }

  /// Lấy thời gian inactive hiện tại (nếu đang ở background)
  int get currentInactiveTime {
    if (_backgroundTime != null && _isInBackground) {
      return DateTime.now().difference(_backgroundTime!).inMilliseconds;
    }
    return 0;
  }

  /// Kiểm tra có đang ở background không
  bool get isInBackground => _isInBackground;

  /// Cấu hình thời gian inactive tối đa (cho testing)
  static int get maxInactiveTime => _maxInactiveTime;

  /// Reset service (cho testing)
  void reset() {
    _backgroundTime = null;
    _isInBackground = false;
    _needsRefresh = false;
    debugPrint('AppRefreshService: Service reset');
  }
}
