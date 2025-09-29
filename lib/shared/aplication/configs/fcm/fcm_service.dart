import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Android 13+ uchun notification permission
    await _requestNotificationPermission();

    // Local notifications init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // FCM Token olish
    final token = await _messaging.getToken();
    print("✅ FCM Token: $token");
    // TODO: tokenni serverga yuborish

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 Token yangilandi: $newToken");
      // TODO: yangilangan tokenni serverga yuborish
    });

    // Foreground message listener
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background & Terminated listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Terminated holat (app yopiqdan ochilganda)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  /// 🔹 Foreground notificationni ko‘rsatish
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print("📩 Foreground message: ${message.notification?.title}");

    const androidDetails = AndroidNotificationDetails(
      "default_channel",
      "General Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      notificationDetails,
    );
  }

  /// 🔹 Notificationga bosilganda ishlaydi
  void _handleMessageTap(RemoteMessage message) {
    print("👉 Notification bosildi: ${message.data}");
    // TODO: shu yerda navigate qilishing mumkin (GoRouter/BLoC event)
  }

  /// 🔹 Android 13+ permission
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
