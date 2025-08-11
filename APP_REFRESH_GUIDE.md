# Tính Năng Refresh App Tự Động

## Mô tả
Giống như Facebook, khi người dùng không sử dụng app trong thời gian dài (5 phút), app sẽ tự động refresh khi họ quay lại, ngay cả khi app vẫn còn trong background.

## Cách hoạt động

### 1. Theo dõi thời gian inactive
- `AppRefreshService` theo dõi khi app vào background (`AppLifecycleState.paused`)
- Lưu timestamp khi app pause
- Khi app resume, tính toán thời gian inactive

### 2. Trigger refresh khi cần
```dart
// Nếu inactive > 5 phút → trigger refresh
if (inactiveTime >= _maxInactiveTime) {
  _needsRefresh = true;
  _onRefreshNeeded!(); // Gọi callback
}
```

### 3. Navigation về splash screen
```dart
void _handleAppRefresh() {
  debugPrint('MyApp: Handling app refresh - navigating to splash');
  AppNavigator.go(Routes.splash); // Về splash để refresh
  AppRefreshService().markRefreshed();
}
```

### 4. Clear cache và reload data
```dart
Future<void> _clearAppCaches() async {
  // Clear các cache không quan trọng
  final keysToRemove = [
    'cached_data', 'temp_data', 'last_sync',
    'cached_messages', 'cached_notifications',
    'ui_state', 'scroll_position'
  ];
  
  for (String key in keysToRemove) {
    await AppSP.remove(key);
  }
}
```

## Implementation

### 1. AppRefreshService
```dart
class AppRefreshService {
  static const int _maxInactiveTime = 5 * 60 * 1000; // 5 phút
  DateTime? _backgroundTime;
  VoidCallback? _onRefreshNeeded;
  
  void onAppPaused() {
    _backgroundTime = DateTime.now();
  }
  
  void onAppResumed() {
    if (_backgroundTime != null) {
      final inactiveTime = DateTime.now().difference(_backgroundTime!).inMilliseconds;
      if (inactiveTime >= _maxInactiveTime) {
        _needsRefresh = true;
        _onRefreshNeeded?.call();
      }
    }
  }
}
```

### 2. Integration vào MyApp
```dart
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    AppRefreshService().setRefreshCallback(() {
      _handleAppRefresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppRefreshService().onAppResumed();
        break;
      case AppLifecycleState.paused:
        AppRefreshService().onAppPaused();
        break;
    }
  }
}
```

### 3. Enhanced SplashScreen
```dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleAppRefreshIfNeeded(); // Check refresh trước
    _checkInternetConnection();
  }

  Future<void> _handleAppRefreshIfNeeded() async {
    if (AppRefreshService().needsRefresh) {
      await _clearAppCaches(); // Clear cache
      AppRefreshService().markRefreshed();
    }
  }
}
```

## Quy trình hoạt động

### Trường hợp 1: User quay lại sau < 5 phút
```
1. User minimize app (paused)
2. Sau 3 phút → User mở lại app (resumed)  
3. AppRefreshService: inactiveTime = 3 phút < 5 phút
4. Không refresh → App tiếp tục ở màn hình cũ
```

### Trường hợp 2: User quay lại sau > 5 phút  
```
1. User minimize app (paused) 
2. Sau 10 phút → User mở lại app (resumed)
3. AppRefreshService: inactiveTime = 10 phút > 5 phút
4. Trigger refresh callback
5. Navigate to splash screen
6. Clear caches
7. Re-authenticate và load fresh data
8. Navigate to appropriate screen
```

## Cấu hình

### Thời gian inactive tối đa
```dart
// Trong AppRefreshService
static const int _maxInactiveTime = 5 * 60 * 1000; // 5 phút

// Có thể thay đổi theo nhu cầu:
// 1 phút:   1 * 60 * 1000
// 10 phút: 10 * 60 * 1000  
// 30 phút: 30 * 60 * 1000
```

### Cache keys cần clear
```dart
final keysToRemove = [
  'cached_data',        // Data cache
  'temp_data',          // Temporary data  
  'last_sync',          // Sync timestamps
  'cached_messages',    // Message cache
  'cached_notifications', // Notification cache
  'ui_state',           // UI state
  'scroll_position'     // Scroll positions
];

// Không clear:
// - 'token', 'account', 'user_info' (authentication)
// - 'fcm_token' (push notifications)
// - 'app_settings' (user preferences)
```

## Lợi ích

### 1. Fresh data
- Đảm bảo data luôn mới nhất khi user quay lại
- Tránh hiển thị thông tin cũ/sai

### 2. Memory management  
- Clear cache định kỳ giúp giải phóng memory
- Tránh memory leaks từ data cũ

### 3. User experience
- Giống các app lớn như Facebook, Instagram
- Smooth transition thông qua splash screen

### 4. Security
- Re-authenticate token khi cần
- Clear sensitive cached data

## Debug & Monitoring

### Log messages
```
AppRefreshService: App paused at 2024-01-01 10:00:00
AppRefreshService: App resumed after 600000ms inactive  
AppRefreshService: Max inactive time: 300000ms
AppRefreshService: Refresh needed - inactive too long
MyApp: Handling app refresh - navigating to splash
SplashScreen: Handling app refresh - clearing caches
SplashScreen: App caches cleared successfully
AppRefreshService: Marked as refreshed
```

### Test scenarios
1. **< 5 phút**: Minimize → Wait 3 min → Resume → No refresh
2. **> 5 phút**: Minimize → Wait 10 min → Resume → Refresh triggered  
3. **Force close**: Kill app → Reopen → Normal startup (không phải refresh)
4. **Background tasks**: App in background với background tasks → Vẫn tính inactive

## Lưu ý quan trọng

### 1. Performance impact
- Minimal overhead: chỉ lưu timestamp
- Clear cache nhanh và lightweight
- Splash screen loading nhanh

### 2. Data persistence
- Authentication data được giữ nguyên
- User preferences không bị mất
- Chỉ clear cache tạm thời

### 3. Network usage
- Refresh sẽ trigger API calls mới
- Cân nhắc với data plan của user
- Có thể thêm WiFi-only option

### 4. Edge cases
- App crash → Service reset tự động
- Rapid minimize/resume → Chỉ tính lần cuối
- System-level pause → Vẫn được detect

## Customization

### Thay đổi thời gian refresh
```dart
// Trong AppRefreshService constructor hoặc init method
AppRefreshService.configure(
  maxInactiveTime: Duration(minutes: 10), // 10 phút thay vì 5
);
```

### Custom refresh logic
```dart
AppRefreshService().setRefreshCallback(() {
  // Custom logic thay vì navigate to splash
  _refreshCurrentScreen();
  _reloadCriticalData();
  _showRefreshIndicator();
});
```

### Conditional refresh
```dart
void onAppResumed() {
  // Chỉ refresh nếu có network
  if (await hasNetworkConnection() && needsRefresh) {
    _onRefreshNeeded?.call();
  }
}
```
