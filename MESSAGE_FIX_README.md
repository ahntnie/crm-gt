# Sửa lỗi Crash khi gửi tin nhắn và File Picker trên iOS

## Vấn đề đã được khắc phục

### 1. **Crash khi gửi tin nhắn**
- **Nguyên nhân**: Xử lý file không an toàn, thiếu kiểm tra null và exception handling
- **Giải pháp**: 
  - Thêm kiểm tra null cho WebSocket channel
  - Xử lý exception khi encode file
  - Giới hạn kích thước file (10MB)
  - Gửi file tuần tự thay vì song song để tránh quá tải

### 2. **Không gửi được file/hình ảnh trên iOS**
- **Nguyên nhân**: Thiếu quyền truy cập thư viện ảnh và camera
- **Giải pháp**:
  - Thêm quyền truy cập trong `ios/Runner/Info.plist`
  - Cải thiện xử lý file picker với `withData: true`
  - Xử lý cả path và bytes cho iOS

### 3. **Cải thiện UX cho việc chọn file**
- **Tính năng mới**: Bottom sheet với 2 option chọn file
  - **Thư viện ảnh**: Chọn ảnh từ thư viện với ImagePicker
  - **Chọn tệp**: Chọn file từ thiết bị với FilePicker

### 4. **Cải thiện UX cho bàn phím**
- **Tính năng mới**: Ẩn bàn phím khi tap vào màn hình
  - Tap vào bất kỳ đâu trên màn hình để ẩn bàn phím
  - Cải thiện trải nghiệm đọc tin nhắn
  - Tự động unfocus khỏi TextField

### 5. **Crash khi bấm vào file trên iOS**
- **Nguyên nhân**: `url_launcher` và `Uri.parse()` gây crash trên iOS khi URL không hợp lệ
- **Giải pháp**:
  - **Sử dụng `url_launcher` an toàn**: Thêm try-catch và kiểm tra URL hợp lệ
  - **Xử lý file an toàn**: Kiểm tra file local vs URL trước khi xử lý
  - **Exception handling**: Bắt và xử lý tất cả lỗi
  - **User feedback**: Hiển thị thông tin file và mở website
  - **Fallback mechanism**: Nếu không mở được URL thì hiển thị thông tin file

## Các thay đổi đã thực hiện

### 1. **Cập nhật iOS Permissions** (`ios/Runner/Info.plist`)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Ứng dụng cần truy cập thư viện ảnh để bạn có thể chọn và gửi hình ảnh trong tin nhắn</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Ứng dụng cần quyền lưu ảnh vào thư viện của bạn</string>
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần truy cập camera để bạn có thể chụp ảnh và gửi trong tin nhắn</string>
<key>NSMicrophoneUsageDescription</key>
<string>Ứng dụng cần truy cập microphone để ghi âm tin nhắn thoại</string>
```

### 2. **Cải thiện File Picker** (`lib/presentations/modules/messege/cubit/messege_cubit.dart`)
- Thêm `ImagePicker` cho chọn ảnh từ thư viện
- Cải thiện `FilePicker` cho chọn file từ thiết bị
- Xử lý cả path và bytes
- Tạo file tạm khi cần thiết
- Exception handling cho từng file

### 3. **Cải thiện UI/UX** (`lib/presentations/modules/messege/components/messege_view.dart`)
- **Bottom sheet** với 2 option chọn file
- **GestureDetector** để ẩn bàn phím khi tap
- Loading state khi chọn file
- Disable input khi đang xử lý
- Error handling cho image display
- Better file type detection

### 4. **Sửa lỗi crash khi bấm file** (`lib/presentations/modules/messege/widgets/messege_item.dart`)
- **Sử dụng `url_launcher` an toàn**: Thêm try-catch và kiểm tra URL hợp lệ
- **Xử lý file an toàn**: Kiểm tra file local vs URL
- **Exception handling**: Bắt và xử lý lỗi khi xử lý file
- **User feedback**: Hiển thị thông tin file và mở website
- **Fallback mechanism**: Nếu không mở được URL thì hiển thị thông tin file
- **File type detection**: Cải thiện hiển thị loại file

### 5. **Sửa lỗi crash trong file card** (`lib/presentations/modules/home/widgets/file_card.dart`)
- **Sử dụng `url_launcher` an toàn**: Thêm try-catch và kiểm tra URL hợp lệ
- **Exception handling**: Bắt và xử lý lỗi khi xử lý file
- **User feedback**: Hiển thị thông tin file và mở website
- **Fallback mechanism**: Nếu không mở được URL thì hiển thị thông tin file
- **Ảnh preview**: Vẫn giữ chức năng xem ảnh với PhotoView

### 6. **Thêm Dependencies**
- `path: ^1.8.3` cho xử lý đường dẫn an toàn
- `image_picker: ^1.1.2` cho chọn ảnh từ thư viện

## Cách sử dụng

### 1. **Chọn file**
- Tap vào icon "+" để mở bottom sheet
- **Option 1 - Thư viện ảnh**: Chọn ảnh từ thư viện
  - Hỗ trợ: jpg, jpeg, png, gif, bmp, webp
  - Có thể chọn nhiều ảnh cùng lúc
  - Tự động giảm chất lượng và kích thước
- **Option 2 - Chọn tệp**: Chọn file từ thiết bị
  - Hỗ trợ: jpg, jpeg, png, pdf, doc, docx
  - Có thể chọn nhiều file cùng lúc
- Giới hạn kích thước: 10MB/file

### 2. **Gửi tin nhắn**
- Nhập text và/hoặc chọn file
- Tap nút gửi (icon send)
- File sẽ được encode và gửi qua WebSocket

### 3. **Xem file đã chọn**
- File được hiển thị preview
- Tap "X" để xóa file
- Hình ảnh hiển thị thumbnail

### 4. **Ẩn bàn phím**
- **Tap vào bất kỳ đâu trên màn hình** để ẩn bàn phím
- Hữu ích khi muốn đọc tin nhắn mà không bị che khuất
- Tự động unfocus khỏi TextField

### 5. **Mở file đã gửi (AN TOÀN)**
- **Tap vào file** trong tin nhắn để mở website
- **File local**: Hiển thị thông báo thông tin
- **File URL**: Mở website trong trình duyệt để tải file
- **Lỗi**: Hiển thị thông báo lỗi thân thiện
- **Ảnh**: Vẫn có thể xem fullscreen
- **Fallback**: Nếu không mở được website thì hiển thị thông tin file

## Lưu ý quan trọng

### 1. **iOS**
- Cần cấp quyền truy cập thư viện ảnh lần đầu
- **Thư viện ảnh**: Sử dụng ImagePicker (native iOS picker)
- **Chọn tệp**: Sử dụng FilePicker với `withData: true`
- **Ẩn bàn phím**: Hoạt động tốt trên iOS
- **Mở file**: **Sử dụng url_launcher an toàn** với try-catch để tránh crash

### 2. **Android**
- Không cần thêm quyền đặc biệt
- Cả 2 option đều hoạt động bình thường
- **Ẩn bàn phím**: Hoạt động tốt trên Android
- **Mở file**: **Sử dụng url_launcher an toàn** với try-catch để tránh crash

### 3. **Performance**
- **Thư viện ảnh**: Tự động giảm chất lượng (80%) và kích thước (1920x1920)
- **Chọn tệp**: Giữ nguyên chất lượng gốc
- File được gửi tuần tự để tránh quá tải
- Giới hạn 10MB/file để tránh timeout
- Loading state được hiển thị trong quá trình xử lý

## Testing

### 1. **Test trên iOS Simulator**
```bash
fvm flutter run -d ios
```

### 2. **Test trên iOS Device**
```bash
fvm flutter run -d ios --release
```

### 3. **Test trên Android**
```bash
fvm flutter run -d android
```

## Troubleshooting

### 1. **File không chọn được trên iOS**
- Kiểm tra quyền trong Settings > Privacy & Security > Photos
- Đảm bảo app có quyền truy cập

### 2. **Crash khi gửi file lớn**
- Giảm kích thước file (dưới 10MB)
- Kiểm tra kết nối mạng

### 3. **WebSocket disconnect**
- App sẽ tự động reconnect
- Kiểm tra server WebSocket

### 4. **Ảnh không hiển thị**
- Kiểm tra quyền truy cập thư viện ảnh
- Thử option "Chọn tệp" thay vì "Thư viện ảnh"

### 5. **Bàn phím không ẩn**
- Tap vào vùng trống trên màn hình
- Đảm bảo không tap vào TextField hoặc button

### 6. **Crash khi bấm vào file (ĐÃ SỬA)**
- **Giải pháp**: Sử dụng `url_launcher` an toàn với try-catch
- **Kết quả**: Không còn crash, mở website trong trình duyệt
- **Fallback**: Nếu không mở được website thì hiển thị thông tin file
- **Logging**: Xem console để biết URL file

## Code Examples

### Bottom Sheet với 2 options
```dart
void _showFilePickerOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Option 1: Thư viện ảnh
            _buildOptionTile(
              context: context,
              icon: Icons.photo_library,
              title: 'Thư viện ảnh',
              subtitle: 'Chọn ảnh từ thư viện',
              onTap: () {
                Navigator.pop(context);
                cubit.selectImagesFromGallery();
              },
            ),
            // Option 2: Chọn tệp
            _buildOptionTile(
              context: context,
              icon: Icons.folder_open,
              title: 'Chọn tệp',
              subtitle: 'Chọn tệp từ thiết bị',
              onTap: () {
                Navigator.pop(context);
                cubit.selectFiles();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Ẩn bàn phím khi tap
```dart
void _hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  FocusScope.of(context).unfocus();
}

// Wrap Scaffold với GestureDetector
GestureDetector(
  onTap: _hideKeyboard,
  child: Scaffold(
    // ... rest of the UI
  ),
)
```

### Xử lý file an toàn (Sử dụng url_launcher an toàn)
```dart
Future<void> _handleFileTap(BuildContext context) async {
  try {
    if (mess.fileUrl == null || mess.fileUrl!.isEmpty) {
      _showErrorSnackBar(context, 'File không tồn tại');
      return;
    }

    final fileUrl = mess.fileUrl!;
    
    // Kiểm tra file local
    if (fileUrl.startsWith('file://') || fileUrl.startsWith('/')) {
      final filePath = fileUrl.startsWith('file://') 
          ? fileUrl.substring(7)
          : fileUrl;
      
      final file = File(filePath);
      if (await file.exists()) {
        _showInfoSnackBar(context, 'File local: ${path.basename(file.path)}');
      } else {
        _showErrorSnackBar(context, 'File không tồn tại trên thiết bị');
      }
      return;
    }

    // Kiểm tra URL hợp lệ
    if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
      _showErrorSnackBar(context, 'Đường dẫn file không hợp lệ');
      return;
    }

    // Sử dụng url_launcher an toàn với try-catch
    try {
      final uri = Uri.parse(fileUrl);
      
      // Kiểm tra xem có thể mở URL không
      if (await canLaunchUrl(uri)) {
        // Mở URL trong trình duyệt
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
        _showInfoSnackBar(context, 'Đã mở file trong trình duyệt');
      } else {
        _showErrorSnackBar(context, 'Không thể mở file này');
      }
    } catch (urlError) {
      print('Lỗi khi mở URL: $urlError');
      // Fallback: hiển thị thông tin file
      final fileName = mess.fileName ?? 'File không xác định';
      final fileType = mess.fileType ?? 'Không xác định';
      _showInfoSnackBar(context, 'File: $fileName ($fileType)');
      print('File URL: $fileUrl');
    }
    
  } catch (e) {
    print('Lỗi khi xử lý file: $e');
    _showErrorSnackBar(context, 'Lỗi khi xử lý file: ${e.toString()}');
  }
}
```

### Chọn ảnh từ thư viện
```dart
Future<void> selectImagesFromGallery() async {
  final List<XFile> pickedImages = await _imagePicker.pickMultiImage(
    imageQuality: 80, // Giảm chất lượng
    maxWidth: 1920, // Giới hạn chiều rộng
    maxHeight: 1920, // Giới hạn chiều cao
  );
  
  // Xử lý ảnh đã chọn...
}
```

### Chọn file từ thiết bị
```dart
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
  allowMultiple: true,
  withData: true, // Quan trọng cho iOS
);
```

## Kết luận

Các thay đổi này sẽ giải quyết:
- ✅ Crash khi gửi tin nhắn
- ✅ Không gửi được file trên iOS
- ✅ Cải thiện UX với bottom sheet 2 options
- ✅ Ẩn bàn phím khi tap vào màn hình
- ✅ **Crash khi bấm vào file (ĐÃ SỬA HOÀN TOÀN)**
- ✅ Tối ưu performance cho ảnh
- ✅ Xử lý lỗi tốt hơn
- ✅ Performance optimization
- ✅ **Sử dụng url_launcher an toàn để mở website**

App bây giờ sẽ hoạt động ổn định trên cả iOS và Android khi gửi tin nhắn và file, với trải nghiệm người dùng tốt hơn thông qua việc phân tách rõ ràng giữa chọn ảnh và chọn file, khả năng ẩn bàn phím một cách trực quan, và **xử lý file an toàn với khả năng mở website trong trình duyệt**.
