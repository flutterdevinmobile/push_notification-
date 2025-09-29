import 'package:rentify_nitification/features/notification/data/requests/notification_request.dart';
import 'package:rentify_nitification/features/notification/domain/models/notification_model.dart';
import 'package:rentify_nitification/features/notification/domain/repository/notification_repository.dart';

import '../source/notification_source.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteSource remote;

  NotificationRepositoryImpl({required this.remote});

  @override
  Stream<List<NotificationModel>> listenNotifications({
    required String target,
  }) {
    return remote
        .listenNotifications(
          request: NotificationRequest(target: target),
        )
        .map(
          (dtoList) => dtoList.map((dto) => dto.toDomain()).toList(),
        );
  }

  @override
  Future<void> markAsRead({
    required String notificationId,
    required String fcmNumber,
  }) {
    return remote.markAsRead(
      notificationId: notificationId,
      fcmNumber: fcmNumber,
    );
  }
}
