# Hướng dẫn test thông báo với âm thanh mới

## ⚠️ QUAN TRỌNG: Phải clean install để tạo lại notification channel

Vì Android chỉ tạo notification channel 1 lần, bạn PHẢI xóa app và cài lại để channel mới có hiệu lực.

## Bước 1: Clean install app
```bash
# Xóa app cũ khỏi device
flutter clean
flutter pub get

# Build và install lại
flutter run --release
# HOẶC
flutter install
```

## Bước 2: Kiểm tra logs khi khởi động
Sau khi cài app mới, check console để xem:
```
📱 Creating Android notification channel: crm_notification_channel_v2
   Sound: notification_sound.mp3
   Importance: High
✅ Android notification channel created successfully

Notification permission status: AuthorizationStatus.authorized
Sound permission: AppleNotificationSetting.enabled
Badge permission: AppleNotificationSetting.enabled
Alert permission: AppleNotificationSetting.enabled
```

## Bước 3: Test thông báo background
1. Mở app và để nó khởi động hoàn toàn
2. Đưa app vào background (home button, không swipe up để kill)
3. Gửi push notification qua Firebase Console
4. Kiểm tra âm thanh

## Bước 4: Kiểm tra logs khi nhận thông báo
```
🔊 Showing local notification with custom sound:
   Title: Test Title
   Body: Test Body
   Android Channel: crm_notification_channel_v2
   Android Sound: notification_sound.mp3
   iOS Sound: notification_sound.mp3
✅ Local notification sent successfully
```

## Nếu vẫn không có âm thanh:

### Kiểm tra device settings:
1. **Android**: Settings > Apps > CRM GT > Notifications > Check sound settings
2. **iOS**: Settings > CRM GT > Notifications > Sounds

### Kiểm tra Do Not Disturb:
- Đảm bảo device không ở chế độ im lặng
- Tắt Do Not Disturb mode

### Kiểm tra file âm thanh:
```bash
# Kiểm tra file Android
ls -la android/app/src/main/res/raw/notification_sound.mp3

# Kiểm tra file iOS  
ls -la ios/Runner/notification_sound.mp3
```

### Debug thêm:
Nếu vẫn không work, thêm logging này vào FirebaseApi:
```dart
print('🎵 Sound file exists: ${await File('notification_sound.mp3').exists()}');
```

## Test với Firebase Console:
1. Vào Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Điền title, body
4. Chọn target app
5. Click "Send test message"
