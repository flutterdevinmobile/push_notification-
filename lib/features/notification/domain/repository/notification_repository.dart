import '../models/notification_model.dart';

abstract class NotificationRepository {
  /// 🔔 Firestore streamdan Notification list olish
  Stream<List<NotificationModel>> listenNotifications({
    required String target,
  });

  /// 🔖 Notificationni o‘qilgan deb belgilash
  Future<void> markAsRead({
    required String notificationId,
    required String fcmNumber,
  });
}
