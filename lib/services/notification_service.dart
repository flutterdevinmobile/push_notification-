import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/push_notification_model.dart';

// ------------------ Background handler (top-level) ------------------
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PushNotificationModelAdapter());
  }
  final box = await Hive.openBox<PushNotificationModel>('notifications');

  final id = const Uuid().v4();
  final model = PushNotificationModel(
    id: id,
    title: message.notification?.title ?? message.data['title'],
    body: message.notification?.body ?? message.data['body'],
    data: message.data.isNotEmpty
        ? Map<String, dynamic>.from(message.data)
        : null,
    timestamp: DateTime.now(),
    isRead: false,
  );

  await box.put(model.id, model);

  final fln = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await fln.initialize(const InitializationSettings(android: androidInit));
  await fln.show(
    id.hashCode,
    model.title,
    model.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'rentify_channel',
        'Rentify Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

// ------------------ NotificationService ------------------
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp();

    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PushNotificationModelAdapter());
    }
    await Hive.openBox<PushNotificationModel>('notifications');

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidInit),
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ✅ Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("🔥 Foreground message: ${message.notification?.title}");

      final box = Hive.box<PushNotificationModel>('notifications');
      final id = const Uuid().v4();
      final model = PushNotificationModel(
        id: id,
        title: message.notification?.title ?? message.data['title'],
        body: message.notification?.body ?? message.data['body'],
        data: message.data.isNotEmpty
            ? Map<String, dynamic>.from(message.data)
            : null,
        timestamp: DateTime.now(),
        isRead: false,
      );
      await box.put(model.id, model);

      await flutterLocalNotificationsPlugin.show(
        id.hashCode,
        model.title,
        model.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'rentify_channel',
            'Rentify Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    // ✅ Token olish
    String? token = await FirebaseMessaging.instance.getToken();
    print("📱 FCM Token: $token");
  }

  Box<PushNotificationModel> get box =>
      Hive.box<PushNotificationModel>('notifications');

  List<PushNotificationModel> getAllSorted() {
    final list = box.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> markAsRead(String id) async {
    final model = box.get(id);
    if (model != null) {
      model.isRead = true;
      await box.put(id, model);
    }
  }

  Future<void> delete(String id) async => await box.delete(id);
  Future<void> clearAll() async => await box.clear();
}
