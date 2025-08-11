# Hướng dẫn test âm thanh thông báo khi app bị tắt

## 🎯 Vấn đề đã được khắc phục:

### Trước:
- ✅ App running/background: Có âm thanh tùy chỉnh
- ❌ App terminated: Chỉ có âm thanh mặc định

### Sau:
- ✅ App running/background: Có âm thanh tùy chỉnh  
- ✅ App terminated: Có âm thanh tùy chỉnh

## 🔧 Các thay đổi đã thực hiện:

1. **Tạo Background Message Handler mới** (`background_message_handler.dart`)
2. **Đăng ký handler trong main.dart** trước khi khởi tạo FirebaseApi
3. **Cấu hình AndroidManifest.xml** với âm thanh mặc định
4. **Hướng dẫn server** gửi data-only messages

## 📱 Cách test:

### Bước 1: Clean install app
```bash
flutter clean
flutter pub get
flutter run --release
```

### Bước 2: Test với app terminated
1. Mở app để khởi tạo
2. **TẮT HOÀN TOÀN APP** (swipe up và remove khỏi recent apps)
3. Gửi test notification

### Bước 3: Test với Firebase Console (Data-Only Message)
1. Firebase Console > Cloud Messaging > "Send your first message"
2. **BỎ TRỐNG** Title và Message text
3. Chuyển sang "Additional options" tab
4. Thêm Custom data:
   - Key: `title`, Value: `Test Title`
   - Key: `body`, Value: `Test Body`  
   - Key: `idNoTi`, Value: `123`
5. Chọn target app và gửi

### Bước 4: Kiểm tra logs
Khi app terminated và nhận notification, sẽ thấy logs:
```
🚨 TERMINATED STATE - Handling background message:
📱 Background notification channel created
🔊 Showing background notification with custom sound
✅ Background notification handled successfully
```

## ⚠️ Quan trọng:

### Server phải gửi Data-Only Messages:
```json
{
  "to": "FCM_TOKEN",
  "data": {
    "title": "Tin nhắn mới",
    "body": "Bạn có tin nhắn từ John Doe",
    "idNoTi": "123",
    "idThread": "456"
  }
}
```

### KHÔNG gửi Notification Messages:
```json
{
  "notification": {  // ❌ KHÔNG dùng field này
    "title": "...",
    "body": "..."
  }
}
```

## 🔍 Troubleshooting:

### Nếu vẫn không có âm thanh:
1. Kiểm tra file âm thanh có tồn tại:
   ```bash
   ls -la android/app/src/main/res/raw/notification_sound.mp3
   ls -la ios/Runner/notification_sound.mp3
   ```

2. Kiểm tra device settings:
   - Android: Settings > Apps > CRM GT > Notifications
   - iOS: Settings > CRM GT > Notifications

3. Đảm bảo server gửi **data-only messages**, không phải notification messages

4. Check console logs để xem background handler có chạy không

## ✅ Kết quả mong đợi:
- App terminated: Nghe được âm thanh tùy chỉnh
- App background: Nghe được âm thanh tùy chỉnh
- App foreground: Nghe được âm thanh tùy chỉnh
