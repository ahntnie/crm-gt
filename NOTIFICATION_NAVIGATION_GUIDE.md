# Hướng Dẫn Điều Hướng Thông Báo

## Tính năng
Khi người dùng bấm vào thông báo push, ứng dụng sẽ tự động điều hướng đến màn hình nhắn tin tương ứng với `idThread`.

## Cách hoạt động

### 1. Dữ liệu thông báo cần có
Thông báo push từ server cần chứa các field sau trong `data`:
```json
{
  "idNoTi": "notification_id",
  "idThread": "thread_id_here",
  "title": "Tiêu đề thông báo",
  "body": "Nội dung thông báo"
}
```

### 2. Xử lý các trạng thái ứng dụng

#### A. Ứng dụng đang chạy foreground
- Thông báo được xử lý bởi `_handleForeground()`
- Hiển thị local notification
- Khi bấm vào thông báo → gọi `onNotificationTap()`

#### B. Ứng dụng đang chạy background  
- Thông báo được xử lý bởi `_handleBackground()`
- Hiển thị local notification
- Khi bấm vào thông báo → gọi `onNotificationTap()`

#### C. Ứng dụng bị đóng hoàn toàn (terminated)
- Thông báo được xử lý bởi `_handleInitialMessage()`
- Tự động điều hướng sau khi ứng dụng khởi động

### 3. Logic điều hướng

```dart
static void onNotificationTap(NotificationResponse response) async {
  try {
    final data = jsonDecode(response.payload ?? '{}');
    String idThread = data['idThread'] ?? '';
    
    // Điều hướng đến màn hình nhắn tin nếu có idThread
    if (idThread.isNotEmpty) {
      await AppNavigator.push(Routes.messege, idThread);
    }
    
    await _resetBadgeCount();
  } catch (e) {
    print('Error in onNotificationTap: $e');
  }
}
```

### 4. Xử lý ứng dụng terminated

```dart
Future<void> _handleInitialMessage() async {
  RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
  
  if (initialMessage != null) {
    final idThread = initialMessage.data['idThread'] ?? '';
    
    // Delay để đảm bảo app đã khởi tạo hoàn toàn
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (idThread.isNotEmpty) {
      await AppNavigator.push(Routes.messege, idThread);
    }
  }
}
```

## Cách test

### 1. Test với Firebase Console
1. Vào Firebase Console > Cloud Messaging
2. Tạo thông báo mới
3. Trong phần "Additional options" > "Custom data", thêm:
   - Key: `idThread`, Value: `your_thread_id`
   - Key: `idNoTi`, Value: `your_notification_id`

### 2. Test với FCM API
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Tin nhắn mới",
      "body": "Bạn có tin nhắn mới từ nhóm chat"
    },
    "data": {
      "idThread": "thread_123",
      "idNoTi": "notification_456"
    }
  }'
```

### 3. Test các trường hợp
1. **Foreground**: Mở app → gửi thông báo → bấm vào thông báo
2. **Background**: Mở app → nhấn home → gửi thông báo → bấm vào thông báo  
3. **Terminated**: Đóng hoàn toàn app → gửi thông báo → bấm vào thông báo

## Lưu ý quan trọng

### 1. Dữ liệu bắt buộc
- `idThread` phải có giá trị để điều hướng thành công
- Nếu `idThread` rỗng, sẽ chỉ reset badge count

### 2. Timing
- Có delay 1 giây khi xử lý terminated state để đảm bảo app đã khởi tạo
- Navigation có thể fail nếu context chưa sẵn sàng

### 3. Error handling
- Tất cả lỗi đều được log ra console
- Ứng dụng sẽ không crash nếu navigation fail

### 4. Badge count
- Badge count được reset sau mỗi lần bấm thông báo
- Cần implement logic cập nhật badge count thực tế

## Debug

### Kiểm tra log
```bash
# Android
adb logcat | grep -i "notification\|firebase"

# iOS  
# Xem trong Xcode console
```

### Các log quan trọng
- `Received idThread (background/foreground): ...`
- `Tapped idThread: ...`
- `Navigated to message screen with idThread: ...`
- `App opened from terminated state via notification`

## Troubleshooting

### Vấn đề thường gặp
1. **Navigation không hoạt động**: Kiểm tra `idThread` có giá trị không
2. **App crash khi navigation**: Đảm bảo context đã sẵn sàng
3. **Không nhận được thông báo**: Kiểm tra FCM token và server key
4. **Terminated state không hoạt động**: Kiểm tra `getInitialMessage()`
