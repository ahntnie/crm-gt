# Tính Năng Thông Báo Thông Minh

## Mô tả
Khi người dùng đang ở trong màn hình nhắn tin của một cuộc trò chuyện cụ thể, hệ thống sẽ **không hiển thị thông báo** cho các tin nhắn mới trong cuộc trò chuyện đó.

## Cách hoạt động

### 1. Theo dõi trạng thái màn hình
- `CurrentScreenService` theo dõi màn hình hiện tại và `idThread` đang mở
- Khi vào màn hình chat → set `currentScreen = 'messege'` và `currentThreadId = idThread`
- Khi rời khỏi → clear trạng thái

### 2. Logic kiểm tra thông báo
```dart
// Trong _showLocalNotification()
final idThread = data['idThread'] ?? '';
if (idThread.isNotEmpty && CurrentScreenService().isInThread(idThread)) {
  print('Skipping notification - user is currently in thread: $idThread');
  return; // Không hiển thị thông báo
}
```

### 3. Quản lý lifecycle
- **Vào màn hình chat**: Set trạng thái hiện tại
- **Ra khỏi màn hình**: Clear trạng thái
- **App vào background**: Clear trạng thái (để nhận thông báo khi ở nền)
- **App quay lại foreground**: Restore trạng thái nếu vẫn ở màn hình chat

## Các trường hợp xử lý

### ✅ Không hiển thị thông báo khi:
1. **Đang ở trong cuộc trò chuyện đó**: User đang xem tin nhắn trực tiếp
2. **Đang gõ tin nhắn**: User đang tương tác với cuộc trò chuyện

### ✅ Vẫn hiển thị thông báo khi:
1. **Ở màn hình khác**: Home, Profile, Settings, v.v.
2. **Ở cuộc trò chuyện khác**: Đang chat với người/nhóm khác
3. **App ở background**: Đã minimize hoặc switch sang app khác
4. **App bị tắt**: Force close hoặc terminated

## Implementation

### 1. CurrentScreenService
```dart
class CurrentScreenService {
  static final CurrentScreenService _instance = CurrentScreenService._internal();
  factory CurrentScreenService() => _instance;
  CurrentScreenService._internal();

  String? _currentThreadId;
  String? _currentScreen;

  // Kiểm tra có đang ở trong thread cụ thể không
  bool isInThread(String threadId) {
    return _currentThreadId == threadId && _currentScreen == 'messege';
  }

  // Set/clear trạng thái
  void setCurrentThread(String? threadId) { _currentThreadId = threadId; }
  void setCurrentScreen(String? screen) { _currentScreen = screen; }
  void clearCurrentThread() { _currentThreadId = null; }
  void clearCurrentScreen() { _currentScreen = null; }
}
```

### 2. Tích hợp vào MessegeView
```dart
class _MessegeViewContentState extends State<_MessegeViewContent> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    CurrentScreenService().clearCurrentThread();
    CurrentScreenService().clearCurrentScreen();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Restore trạng thái khi quay lại app
        CurrentScreenService().setCurrentScreen('messege');
        CurrentScreenService().setCurrentThread(widget.idDir);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Clear trạng thái khi vào background
        CurrentScreenService().clearCurrentThread();
        CurrentScreenService().clearCurrentScreen();
        break;
    }
  }
}
```

### 3. Cập nhật Firebase notification logic
```dart
Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
  // Kiểm tra xem có đang ở trong thread này không
  final idThread = data['idThread'] ?? '';
  if (idThread.isNotEmpty && CurrentScreenService().isInThread(idThread)) {
    print('Skipping notification - user is currently in thread: $idThread');
    return; // Skip notification
  }

  // Hiển thị thông báo bình thường...
}
```

## Lợi ích

### 1. Trải nghiệm người dùng tốt hơn
- Không bị spam thông báo khi đang đọc tin nhắn
- Tập trung vào cuộc trò chuyện hiện tại
- Giảm distraction không cần thiết

### 2. Logic thông minh
- Chỉ ẩn thông báo cho cuộc trò chuyện đang mở
- Vẫn nhận thông báo từ các cuộc trò chuyện khác
- Tự động restore khi chuyển màn hình

### 3. Xử lý lifecycle đầy đủ
- Background/Foreground switching
- Screen navigation
- App termination/restart

## Debug & Monitoring

### Log messages
```
CurrentScreenService: Set current thread to: thread_123
CurrentScreenService: Set current screen to: messege
CurrentScreenService: isInThread(thread_123) = true (current: thread_123, screen: messege)
Skipping notification - user is currently in thread: thread_123
CurrentScreenService: Clear current thread (was: thread_123)
```

### Test scenarios
1. **Trong chat** → Gửi tin nhắn → Không thấy notification
2. **Trong chat** → Minimize app → Gửi tin nhắn → Thấy notification
3. **Trong chat A** → Gửi tin nhắn chat B → Thấy notification
4. **Ở home** → Gửi tin nhắn → Thấy notification

## Lưu ý

### 1. Performance
- Service sử dụng Singleton pattern, lightweight
- Chỉ lưu trữ 2 string variables
- Không có heavy operations

### 2. Memory management
- Tự động clear khi dispose
- Observer pattern được cleanup đúng cách
- Không có memory leaks

### 3. Edge cases
- App crash → Service reset tự động
- Multiple instances → Singleton đảm bảo consistency
- Rapid screen switching → State được update realtime
