# Hướng dẫn gửi Push Notification với âm thanh tùy chỉnh

## ⚠️ Quan trọng: Server phải gửi đúng format

Để âm thanh tùy chỉnh hoạt động khi app bị tắt, server cần gửi **DATA-ONLY messages** thay vì notification messages.

## ❌ SAI - Notification Message (không có âm thanh tùy chỉnh khi app tắt):
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Tin nhắn mới",
    "body": "Bạn có tin nhắn từ John Doe"
  },
  "data": {
    "idNoTi": "123",
    "idThread": "456"
  }
}
```

## ✅ ĐÚNG - Data-Only Message (có âm thanh tùy chỉnh):
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

## Giải thích:

### Notification Messages:
- **App running/background**: Firebase → Flutter → Custom sound ✅
- **App terminated**: Firebase → System → Default sound ❌

### Data-Only Messages:
- **App running/background**: Firebase → Flutter → Custom sound ✅  
- **App terminated**: Firebase → Background Handler → Custom sound ✅

## Cách test với Firebase Console:

### Test Data-Only Message:
1. Vào Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. **Bỏ trống** Title và Message text
4. Chuyển sang tab "Additional options"
5. Thêm Custom data:
   - `title`: "Test Title"
   - `body`: "Test Body"
   - `idNoTi`: "123"
   - `idThread`: "456"

### Test với cURL:
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
-H "Authorization: key=YOUR_SERVER_KEY" \
-H "Content-Type: application/json" \
-d '{
  "to": "FCM_TOKEN",
  "data": {
    "title": "Test Notification",
    "body": "Testing custom sound when app is terminated",
    "idNoTi": "123",
    "idThread": "456"
  }
}'
```

## Lưu ý:
- Server key lấy từ Firebase Console > Project Settings > Cloud Messaging
- FCM Token được print trong console khi app khởi động
- Data-only messages sẽ luôn đi qua background handler, đảm bảo âm thanh tùy chỉnh hoạt động
