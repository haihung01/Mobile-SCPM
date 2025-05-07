import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Khởi tạo flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FirebaseMsg {
  final FirebaseMessaging _msgService = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    String? token = await _msgService.getToken();
    print("Token device: $token");
    return token;
  }
  // Khởi tạo FCM
  Future<void> initFCM() async {
    // Yêu cầu quyền thông báo
    NotificationSettings settings = await _msgService.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Lấy FCM token
    String? token = await _msgService.getToken();
    print("Token device: $token");

    // Khởi tạo local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked: ${response.payload}');
        // Xử lý khi nhấn thông báo, ví dụ: điều hướng
      },
    );

    // Xử lý thông báo background
    FirebaseMessaging.onBackgroundMessage(handleNotification);

    // Xử lý thông báo foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.messageId}');
      if (message.notification != null) {
        print('Notification: ${message.notification!.title}');
        _showNotification(
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
        );
      }
      if (message.data.isNotEmpty) {
        print('Data: ${message.data}');
      }
    });

    // Xử lý khi nhấn vào thông báo
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.messageId}');
      if (message.notification != null) {
        print('Notification: ${message.notification!.title}');
      }
      if (message.data.isNotEmpty) {
        print('Data: ${message.data}');
      }
      // Điều hướng đến màn hình cụ thể, ví dụ: ChatScreen
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      channelDescription: 'Notifications from Firebase Cloud Messaging',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
    DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Hàm static xử lý thông báo background
  static Future<void> handleNotification(RemoteMessage message) async {
    print('Background message: ${message.messageId}');
    if (message.notification != null) {
      print('Background notification: ${message.notification!.title}');
    }
    if (message.data.isNotEmpty) {
      print('Data: ${message.data}');
    }
  }
}