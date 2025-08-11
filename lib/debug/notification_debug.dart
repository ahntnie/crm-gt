import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationDebugScreen extends StatefulWidget {
  @override
  _NotificationDebugScreenState createState() => _NotificationDebugScreenState();
}

class _NotificationDebugScreenState extends State<NotificationDebugScreen> {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
        
    await _localNotifications.initialize(initSettings);

    // Tạo notification channel cho debug
    const AndroidNotificationChannel debugChannel = AndroidNotificationChannel(
      'debug_notification_channel',
      'Debug Notifications',
      description: 'Channel để test âm thanh thông báo',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(debugChannel);
        
    print('🐛 Debug notification channel created');
  }

  Future<void> _testLocalNotification() async {
    print('🧪 Testing local notification with custom sound...');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'debug_notification_channel',
      'Debug Notifications',
      channelDescription: 'Channel để test âm thanh thông báo',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      enableVibration: true,
      enableLights: true,
      autoCancel: true,
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

    await _localNotifications.show(
      999,
      '🔊 Test Âm Thanh',
      'Đây là test local notification với âm thanh tùy chỉnh',
      platformDetails,
      payload: jsonEncode({
        'test': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      }),
    );
    
    print('✅ Local notification sent');
  }

  Future<void> _testSystemNotification() async {
    print('🧪 Testing system default notification...');
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default',
      'Default',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      // Không set custom sound - dùng default
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // Không set custom sound - dùng default
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      998,
      '🔔 Test Default Sound',
      'Đây là test với âm thanh mặc định',
      platformDetails,
    );
    
    print('✅ System notification sent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐛 Notification Debug'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔊 Test Âm Thanh Thông Báo', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Các test này sẽ giúp xác định vấn đề âm thanh:'),
                    SizedBox(height: 12),
                    Text('1. Local notification với âm thanh tùy chỉnh'),
                    Text('2. System notification với âm thanh mặc định'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: _testLocalNotification,
              icon: Icon(Icons.volume_up),
              label: Text('Test Âm Thanh Tùy Chỉnh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            
            SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _testSystemNotification,
              icon: Icon(Icons.notifications),
              label: Text('Test Âm Thanh Mặc Định'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            
            SizedBox(height: 20),
            
            Card(
              color: Colors.yellow[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📋 Cách Test:', 
                         style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1. Nhấn các nút test ở trên'),
                    Text('2. Kiểm tra âm thanh có phát hay không'),
                    Text('3. Check console logs để debug'),
                    Text('4. So sánh âm thanh tùy chỉnh vs mặc định'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚠️ Lưu Ý:', 
                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 8),
                    Text('• Đảm bảo device không ở chế độ im lặng'),
                    Text('• Kiểm tra volume notification của device'),
                    Text('• Test trên device thật, không phải simulator'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
