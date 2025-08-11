# Hướng dẫn khắc phục sự cố thông báo

## Các bước đã thực hiện để khắc phục âm thanh thông báo:

### 1. ✅ Cập nhật AndroidManifest.xml
- Thêm cấu hình âm thanh mặc định: `@raw/notification_sound`
- Đảm bảo có permission `POST_NOTIFICATIONS`

### 2. ✅ Cập nhật FirebaseApi
- Thêm âm thanh tùy chỉnh cho Android: `RawResourceAndroidNotificationSound('notification_sound')`
- Thêm âm thanh tùy chỉnh cho iOS: `sound: 'notification_sound.caf'`
- Cải thiện cấu hình notification channel
- Thêm logging để debug permission

### 3. ✅ Tạo hướng dẫn thêm file âm thanh
- Android: `android/app/src/main/res/raw/notification_sound.mp3`
- iOS: `ios/Runner/notification_sound.caf` (cần thêm vào Xcode project)

## Cách kiểm tra và debug:

### 1. Kiểm tra permission thông báo
Khi khởi động app, check console log để xem:
```
Notification permission status: AuthorizationStatus.authorized
Sound permission: AppleNotificationSetting.enabled
Badge permission: AppleNotificationSetting.enabled
Alert permission: AppleNotificationSetting.enabled
```

### 2. Test thông báo background
1. Build và cài đặt app
2. Đưa app vào background (không tắt hoàn toàn)
3. Gửi push notification qua Firebase Console hoặc API
4. Kiểm tra âm thanh có phát hay không

### 3. Test thông báo foreground
1. Giữ app ở foreground
2. Gửi push notification
3. Kiểm tra local notification có âm thanh hay không

## Các nguyên nhân có thể gây ra không có âm thanh:

### Android:
1. ❌ Thiếu file âm thanh: `android/app/src/main/res/raw/notification_sound.mp3`
2. ❌ Cài đặt âm thanh thông báo của device bị tắt
3. ❌ App đang ở chế độ "Do Not Disturb"
4. ❌ Channel notification không được tạo đúng cách

### iOS:
1. ❌ Thiếu file âm thanh: `ios/Runner/notification_sound.caf`
2. ❌ File âm thanh không được add vào Xcode project
3. ❌ Cài đặt âm thanh của device bị tắt
4. ❌ App không có permission âm thanh

## Cách test nhanh:
1. Xóa app và cài đặt lại để reset notification permissions
2. Khi app yêu cầu permission, chọn "Allow" và đảm bảo âm thanh được enable
3. Test với Firebase Console: Firebase > Cloud Messaging > Send test message

## Lưu ý quan trọng:
- File âm thanh phải được thêm TRƯỚC khi build app
- Sau khi thêm file âm thanh, cần clean và rebuild project
- Trên iOS, file âm thanh phải được add vào Xcode project bundle
- Notification channel trên Android chỉ được tạo 1 lần, nếu cần thay đổi phải uninstall app
