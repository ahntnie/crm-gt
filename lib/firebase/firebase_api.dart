import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function để xử lý thông báo background
Future<void> _handleBackground(RemoteMessage message) async {
  print('Background Notification:');
  print("Data: ${message.data}");
  print("Notification: ${message.notification?.title}, ${message.notification?.body}");

  // Lấy title, body và idNoTi từ data hoặc notification
  final title = message.notification?.title ?? message.data['title'] ?? 'No Title';
  final body = message.notification?.body ?? message.data['body'] ?? 'No Body';
  final idNoTi = message.data['idNoTi'] ?? 'No ID';
  print('Received idNoTi (background): $idNoTi');

  await _showLocalNotification(title, body, message.data);
  await FirebaseApi._updateBadgeCount();
}

// Top-level function để hiển thị thông báo cục bộ
Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'crm_notification_channel_id',
    'CRM Notifications',
    channelDescription: 'Thông báo CRM-GT',
    importance: Importance.high,
    priority: Priority.high,
    largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
    icon: '@drawable/notification',
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await localNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    platformDetails,
    payload: jsonEncode(data),
  );
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // static const MethodChannel _channel = MethodChannel("project/countBadge");
  String FCM_TOPIC_ALL = "crm_gt_all";
  String? token;

  Future<void> initNotifications() async {
    // Yêu cầu quyền thông báo
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    await firebaseMessaging.subscribeToTopic(FCM_TOPIC_ALL);
    FirebaseMessaging.onBackgroundMessage(_handleBackground);
    FirebaseMessaging.onMessage.listen(_handleForeground);

    // Lấy và lưu FCM token
    token = await firebaseMessaging.getToken();
    print('FCM Token: $token');
    // Gửi token lên server qua API để lưu vào bảng user
    // await sendTokenToServer(token);

    await _initializeLocalNotifications();
  }

  String? getToken() {
    return token;
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    print('Foreground Notification:');
    print("Data: ${message.data}");
    print("Notification: ${message.notification?.title}, ${message.notification?.body}");

    // Lấy title, body và idNoTi từ data hoặc notification
    final title = message.notification?.title ?? message.data['title'] ?? 'No Title';
    final body = message.notification?.body ?? message.data['body'] ?? 'No Body';
    final idNoTi = message.data['idNoTi'] ?? 'No ID';
    print('Received idNoTi (foreground): $idNoTi');

    await _showLocalNotification(title, body, message.data);
    await _updateBadgeCount();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    // Tạo kênh thông báo cho Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'crm_notification_channel_id',
      'CRM Notifications',
      description: 'Thông báo CRM-GT',
      importance: Importance.high,
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void onNotificationTap(NotificationResponse response) async {
    try {
      final data = jsonDecode(response.payload ?? '{}');
      print('Notification tapped: $data');
      String idNoTi = data['idNoTi'] ?? 'No ID';
      print('Tapped idNoTi: $idNoTi');

      // Điều hướng hoặc xử lý thêm dựa trên idNoTi
      // await _navigationService.navigateToNotificationDetailPage(idNoti: idNoTi);
      await _resetBadgeCount();
    } catch (e) {
      print('Error in onNotificationTap: $e');
    }
  }

  static Future<void> _updateBadgeCount() async {
    try {
      // Cập nhật số lượng badge (giả sử dùng AppSP hoặc tương tự)
      print('Updating badge count');
    } catch (e) {
      print('Error updating badge count: $e');
    }
  }

  static Future<void> _resetBadgeCount() async {
    try {
      // Reset badge count
      print('Resetting badge count');
    } catch (e) {
      print('Error resetting badge count: $e');
    }
  }
}
