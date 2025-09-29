import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify_nitification/shared/aplication/exceptions/base_exception.dart';
import 'package:rentify_nitification/shared/aplication/exceptions/connection_exception.dart';
import 'package:rentify_nitification/shared/aplication/utils/safed.dart';

import '../dto/notification_dto.dart';
import '../requests/notification_request.dart';

final class NotificationRemoteSource {
  final FirebaseFirestore firestore;

  NotificationRemoteSource({required this.firestore});

  /// Stream with Safed wrapper (error-handling bilan)
  Stream<Safed<BaseException, List<NotificationDto>>> getNotifications({
    required NotificationRequest request,
  }) async* {
    try {
      final query = firestore.collection("notifications").where("target",
          whereIn: ["all", request.target]).orderBy("date", descending: true);

      yield* query.snapshots().map(
        (snapshot) {
          final list = snapshot.docs.map((doc) {
            final json = {
              "id": doc.id,
              ...doc.data(),
            };
            return NotificationDto.fromJson(json);
          }).toList();

          return Success(list);
        },
      );
    } catch (e, st) {
      yield Failure(
        NetworkException(
          title: "Firestore Error",
          description: e.toString(),
          code: -1,
          origin: e,
          stackTrace: st,
        ),
      );
    }
  }

  Stream<List<NotificationDto>> listenNotifications({
    required NotificationRequest request,
  }) {
    final query = firestore.collection("notifications").where("target",
        whereIn: ["all", request.target]).orderBy("date", descending: true);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => NotificationDto.fromJson({
                  "id": doc.id,
                  ...doc.data(),
                }),
              )
              .toList(),
        );
  }

  /// Notificationni o‘qilgan deb belgilash
  Future<void> markAsRead({
    required String notificationId,
    required String fcmNumber,
  }) async {
    try {
      await firestore.collection("notifications").doc(notificationId).update({
        "readBy.$fcmNumber": true,
      });
    } catch (e) {
      throw NetworkException(
        title: "Firestore Error",
        description: e.toString(),
        code: -1,
        origin: e,
        stackTrace: null,
      );
    }
  }
}
