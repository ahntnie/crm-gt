import 'package:flutter/foundation.dart';

/// Service để theo dõi màn hình hiện tại và thread đang mở
class CurrentScreenService {
  static final CurrentScreenService _instance = CurrentScreenService._internal();
  factory CurrentScreenService() => _instance;
  CurrentScreenService._internal();

  // Theo dõi thread hiện tại đang mở
  String? _currentThreadId;

  // Theo dõi màn hình hiện tại
  String? _currentScreen;

  /// Lấy thread ID hiện tại
  String? get currentThreadId => _currentThreadId;

  /// Lấy màn hình hiện tại
  String? get currentScreen => _currentScreen;

  /// Cập nhật thread ID hiện tại khi vào màn hình chat
  void setCurrentThread(String? threadId) {
    _currentThreadId = threadId;
    debugPrint('CurrentScreenService: Set current thread to: $threadId');
  }

  /// Cập nhật màn hình hiện tại
  void setCurrentScreen(String? screen) {
    _currentScreen = screen;
    debugPrint('CurrentScreenService: Set current screen to: $screen');
  }

  /// Kiểm tra có đang ở trong thread cụ thể không
  bool isInThread(String threadId) {
    bool result = _currentThreadId == threadId && _currentScreen == 'messege';
    debugPrint(
        'CurrentScreenService: isInThread($threadId) = $result (current: $_currentThreadId, screen: $_currentScreen)');
    return result;
  }

  /// Kiểm tra có đang ở màn hình chat không
  bool isInMessageScreen() {
    bool result = _currentScreen == 'messege';
    debugPrint('CurrentScreenService: isInMessageScreen() = $result');
    return result;
  }

  /// Xóa thread hiện tại khi rời khỏi màn hình chat
  void clearCurrentThread() {
    debugPrint('CurrentScreenService: Clear current thread (was: $_currentThreadId)');
    _currentThreadId = null;
  }

  /// Xóa màn hình hiện tại
  void clearCurrentScreen() {
    debugPrint('CurrentScreenService: Clear current screen (was: $_currentScreen)');
    _currentScreen = null;
  }

  /// Reset tất cả
  void reset() {
    debugPrint('CurrentScreenService: Reset all');
    _currentThreadId = null;
    _currentScreen = null;
  }
}
