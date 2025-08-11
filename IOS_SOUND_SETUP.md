# Hướng dẫn thêm âm thanh thông báo cho iOS

## Bước 1: Chuẩn bị file âm thanh
1. Tải file âm thanh định dạng .caf, .wav, hoặc .aiff
2. Đổi tên thành `notification_sound.caf`
3. Copy vào thư mục `ios/Runner/`

## Bước 2: Thêm vào Xcode project
1. Mở file `Runner.xcworkspace` trong Xcode
2. Right-click vào folder "Runner" trong project navigator
3. Chọn "Add Files to Runner"
4. Chọn file `notification_sound.caf`
5. Đảm bảo "Add to target: Runner" được check
6. Click "Add"

## Bước 3: Kiểm tra Info.plist (tự động được cập nhật)
File Info.plist sẽ tự động được cập nhật với quyền thông báo khi build.

## Lưu ý:
- File âm thanh iOS phải là định dạng .caf để tương thích tốt nhất
- Độ dài tối đa 30 giây
- Sample rate khuyến nghị: 16kHz hoặc 22kHz
- Có thể chuyển đổi từ .mp3 sang .caf bằng lệnh:
  `afconvert -f caff -d LEI16 input.mp3 notification_sound.caf`
