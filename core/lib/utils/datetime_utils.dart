part of '../core.dart';

/// Utility class for date and time formatting operations
class DateTimeUtils {
  /// Format DateTime thành string hiển thị thông minh
  /// - Hôm nay: HH:mm
  /// - Hôm qua: "Hôm qua"
  /// - Trong tuần: "X ngày trước"
  /// - Lâu hơn: dd/MM/yyyy
  static String formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Hôm qua';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }

  /// Format DateTime cho upload time
  /// Format: dd/MM/yyyy HH:mm
  static String formatUploadTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format DateTime từ string cho upload time
  static String formatUploadTimeFromString(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return formatUploadTime(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  /// Format DateTime thành string ngắn gọn
  /// - Hôm nay: HH:mm
  /// - Khác: dd/MM
  static String formatDateTimeShort(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    }
  }

  /// Kiểm tra xem có phải cùng ngày không
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  /// Lấy thời gian hiện tại dưới dạng string ISO
  static String getCurrentISOString() {
    return DateTime.now().toIso8601String();
  }

  /// Format thời gian cho logging
  static String timePrint() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
  }

  static String convertDate(date, [format]) {
    String formatDate = 'dd/MM/yyyy';
    if (format != null) {
      formatDate = format;
    }

    if (date is String && date.isNotEmpty) {
      DateTime dateTime = DateTime.parse(date);
      return formatDateTimes(dateTime.millisecondsSinceEpoch, formatDate) ?? '';
    } else if (date is DateTime) {
      return formatDateTimes(date.millisecondsSinceEpoch, formatDate) ?? '';
    } else {
      return '';
    }
  }

  static String? formatDateTimes(int? time, String s) {
    if (time == null) return null;

    final date = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat(s).format(date);
  }
}
