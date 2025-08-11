import 'dart:convert';

import 'package:crm_gt/core/services/current_screen_service.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function để xử lý thông báo background
Future<void> _handleBackground(RemoteMessage message) async {
  print('Background Notification:');
  print("Data: ${message.data}");
  print("Notification: ${message.notification?.title}, ${message.notification?.body}");

  // Lấy title, body, idNoTi và idThread từ data hoặc notification
  final title = message.notification?.title ?? message.data['title'] ?? 'No Title';
  final body = message.notification?.body ?? message.data['body'] ?? 'No Body';
  final idNoTi = message.data['idNoTi'] ?? 'No ID';
  final idThread = message.data['idThread'] ?? '';
  print('Received idNoTi (background): $idNoTi');
  print('Received idThread (background): $idThread');

  await _showLocalNotification(title, body, message.data);
  await FirebaseApi._updateBadgeCount();
}

// Top-level function để hiển thị thông báo cục bộ
Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
  // Kiểm tra xem có đang ở trong thread này không
  final idThread = data['idThread'] ?? '';
  if (idThread.isNotEmpty && CurrentScreenService().isInThread(idThread)) {
    print('Skipping notification - user is currently in thread: $idThread');
    return;
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'crm_notification_channel_id',
    'CRM Notifications',
    channelDescription: 'Thông báo CRM-GT',
    importance: Importance.high,
    priority: Priority.high,
    largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
    icon: '@drawable/notification',
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
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
      criticalAlert: false,
      announcement: false,
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

    // Xử lý thông báo khi ứng dụng được mở từ trạng thái terminated
    await _handleInitialMessage();
  }

  String? getToken() {
    return token;
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    print('Foreground Notification:');
    print("Data: ${message.data}");
    print("Notification: ${message.notification?.title}, ${message.notification?.body}");

    // Lấy title, body, idNoTi và idThread từ data hoặc notification
    final title = message.notification?.title ?? message.data['title'] ?? 'No Title';
    final body = message.notification?.body ?? message.data['body'] ?? 'No Body';
    final idNoTi = message.data['idNoTi'] ?? 'No ID';
    final idThread = message.data['idThread'] ?? '';
    print('Received idNoTi (foreground): $idNoTi');
    print('Received idThread (foreground): $idThread');

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
      playSound: true,
      enableVibration: true,
      enableLights: true,
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
      String idThread = data['idThread'] ?? '';
      print('Tapped idNoTi: $idNoTi');
      print('Tapped idThread: $idThread');

      // Điều hướng đến màn hình nhắn tin nếu có idThread
      if (idThread.isNotEmpty) {
        try {
          await AppNavigator.push(Routes.messege, idThread);
          print('Navigated to message screen with idThread: $idThread');
        } catch (e) {
          print('Error navigating to message screen: $e');
        }
      } else {
        print('idThread is empty, cannot navigate to message screen');
      }

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

  // Xử lý thông báo khi ứng dụng được mở từ trạng thái terminated
  Future<void> _handleInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

      if (initialMessage != null) {
        print('App opened from terminated state via notification');
        print('Initial message data: ${initialMessage.data}');

        final idThread = initialMessage.data['idThread'] ?? '';
        final idNoTi = initialMessage.data['idNoTi'] ?? '';

        print('Initial idThread: $idThread');
        print('Initial idNoTi: $idNoTi');

        // Delay để đảm bảo app đã khởi tạo hoàn toàn
        await Future.delayed(const Duration(milliseconds: 1000));

        if (idThread.isNotEmpty) {
          try {
            await AppNavigator.push(Routes.messege, idThread);
            print('Navigated to message screen from terminated state with idThread: $idThread');
          } catch (e) {
            print('Error navigating from terminated state: $e');
          }
        }

        await _resetBadgeCount();
      }
    } catch (e) {
      print('Error handling initial message: $e');
    }
  }
}
