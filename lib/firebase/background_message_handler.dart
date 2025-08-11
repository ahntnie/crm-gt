import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global instance để sử dụng trong background
final FlutterLocalNotificationsPlugin _localNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

// Top-level function để xử lý thông báo khi app terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🚨 TERMINATED STATE - Handling background message:');
  print('Message ID: ${message.messageId}');
  print('Data: ${message.data}');
  print('Notification: ${message.notification?.title}, ${message.notification?.body}');

  // Khởi tạo local notifications nếu chưa có
  await _initializeBackgroundNotifications();
  
  // Lấy thông tin từ message
  final title = message.notification?.title ?? message.data['title'] ?? 'CRM GT';
  final body = message.notification?.body ?? message.data['body'] ?? 'Bạn có tin nhắn mới';
  
  // Hiển thị local notification với âm thanh tùy chỉnh
  await _showBackgroundNotification(title, body, message.data);
  
  print('✅ Background notification handled successfully');
}

Future<void> _initializeBackgroundNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@drawable/ic_notification');
  
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);
      
  await _localNotificationsPlugin.initialize(initSettings);

  // Tạo notification channel cho background
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'crm_background_channel',
    'CRM Background Notifications',
    description: 'Thông báo CRM khi app bị tắt',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
    enableLights: true,
    showBadge: true,
  );
  
  await _localNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
      
  print('📱 Background notification channel created');
}

Future<void> _showBackgroundNotification(String title, String body, Map<String, dynamic> data) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'crm_background_channel',
    'CRM Background Notifications',
    channelDescription: 'Thông báo CRM khi app bị tắt',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/ic_notification',
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
    enableLights: true,
    autoCancel: true,
    ongoing: false,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'notification_sound.mp3',
    interruptionLevel: InterruptionLevel.active,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  print('🔊 Showing background notification with custom sound');
  
  await _localNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    platformDetails,
    payload: jsonEncode(data),
  );
}
