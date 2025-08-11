# 🐛 Debug Âm Thanh Thông Báo Khi App Terminated

## 🎯 Vấn đề hiện tại:
App không phát âm thanh thông báo khi bị tắt hoàn toàn (terminated state).

## 🔧 Các thay đổi đã thực hiện:

### 1. ✅ Background Message Handler
- Tạo `background_message_handler.dart` để xử lý thông báo khi app terminated
- Đăng ký trong `main.dart` với `FirebaseMessaging.onBackgroundMessage()`

### 2. ✅ Notification Debug Screen  
- Tạo debug screen để test âm thanh local notifications
- Thêm route `/notification-debug`
- Thêm debug button vào Home screen (icon bug)

### 3. ✅ File âm thanh đã có:
- Android: `android/app/src/main/res/raw/notification_sound.mp3` ✅
- iOS: `ios/Runner/notification_sound.mp3` ✅

## 📱 Cách test từng bước:

### Bước 1: Build và cài đặt app
```bash
fvm flutter clean
fvm flutter pub get
fvm flutter run --release
```

### Bước 2: Test Local Notifications
1. Mở app
2. Nhấn icon bug (🐛) ở Home screen  
3. Nhấn "Test Âm Thanh Tùy Chỉnh"
4. Kiểm tra có nghe âm thanh hay không
5. Nhấn "Test Âm Thanh Mặc Định" để so sánh

**Kết quả mong đợi:** Nghe được 2 âm thanh khác nhau

### Bước 3: Test Background Notifications (App running)
1. Giữ app mở
2. Gửi data-only message từ server/Firebase Console
3. Kiểm tra âm thanh

### Bước 4: Test Terminated Notifications (Quan trọng nhất!)
1. **TẮT HOÀN TOÀN APP** (swipe up, remove khỏi recent apps)
2. Gửi data-only message từ server
3. Kiểm tra có nghe âm thanh hay không

## 🚀 Test với Firebase Console:

### Data-Only Message (ĐÚNG):
1. Firebase Console > Cloud Messaging > "Send your first message"
2. **BỎ TRỐNG Title và Message text**
3. Chọn target app
4. Chuyển sang "Additional options" tab
5. Thêm Custom data:
   ```
   title: Test Terminated
   body: Testing sound when app is killed
   idNoTi: 123
   idThread: 456
   ```
6. Send test message

## 🔍 Debug Logs để kiểm tra:

### Khi app khởi động:
```
📱 Creating Android notification channel: crm_notification_channel_v2
✅ Android notification channel created successfully
Notification permission status: AuthorizationStatus.authorized
```

### Khi app terminated và nhận notification:
```
🚨 TERMINATED STATE - Handling background message:
📱 Background notification channel created  
🔊 Showing background notification with custom sound
✅ Background notification handled successfully
```

### Khi test local notification:
```
🧪 Testing local notification with custom sound...
✅ Local notification sent
```

## ⚠️ Các vấn đề có thể gặp:

### 1. iOS - File âm thanh chưa được add vào Xcode project:
**Giải pháp:**
1. Mở `ios/Runner.xcworkspace` trong Xcode
2. Right-click vào "Runner" folder
3. Chọn "Add Files to Runner"
4. Chọn file `notification_sound.mp3`
5. Đảm bảo "Add to target: Runner" được check

### 2. Notification Channel đã tồn tại với cấu hình cũ:
**Giải pháp:** Uninstall và cài lại app để tạo channel mới

### 3. Server vẫn gửi notification messages thay vì data-only:
**Giải pháp:** Đảm bảo server gửi đúng format (không có field `notification`)

### 4. Device settings:
- Kiểm tra notification permission
- Kiểm tra volume notification
- Tắt Do Not Disturb mode
- Test trên device thật, không phải simulator

## 🎯 Test Cases:

| Trạng thái App | Loại Message | Âm Thanh Mong Đợi |
|---|---|---|
| Foreground | Data-only | ✅ Custom sound |
| Background | Data-only | ✅ Custom sound |
| Terminated | Data-only | ✅ Custom sound |
| Terminated | Notification | ❌ Default sound |

## 🔧 Nếu vẫn không hoạt động:

1. **Check file permissions:**
   ```bash
   ls -la android/app/src/main/res/raw/notification_sound.mp3
   ls -la ios/Runner/notification_sound.mp3
   ```

2. **Check console logs** khi gửi notification

3. **Test với notification khác** (WhatsApp, Telegram) để đảm bảo device sound hoạt động

4. **Thử file âm thanh khác** (có thể file hiện tại bị lỗi)

5. **Test trên device khác** để loại trừ vấn đề device-specific
