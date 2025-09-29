// notification_event.dart
import 'package:equatable/equatable.dart';

import '../../../domain/models/notification_model.dart';
import '../../../domain/payloads/notification_payload.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

final class NotificationStarted extends NotificationEvent {
  final NotificationPayload payload;
  const NotificationStarted(this.payload);

  @override
  List<Object?> get props => [payload];
}

final class NotificationMarkedAsRead extends NotificationEvent {
  final String notificationId;
  final String fcmNumber;
  const NotificationMarkedAsRead(
      {required this.notificationId, required this.fcmNumber});

  @override
  List<Object?> get props => [notificationId, fcmNumber];
}

/// 🔒 faqat Bloc ichida foydalaniladi
final class EmitNotifications extends NotificationEvent {
  final List<NotificationModel> notifications;
  const EmitNotifications(this.notifications);

  @override
  List<Object?> get props => [notifications];
}
