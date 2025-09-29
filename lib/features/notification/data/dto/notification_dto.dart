import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify_nitification/features/notification/domain/models/notification_model.dart';

class NotificationDto {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String target;
  final Map<String, dynamic> readBy;

  NotificationDto({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.target,
    required this.readBy,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      date: (json['date'] as Timestamp).toDate(),
      target: json['target'] as String,
      readBy: Map<String, dynamic>.from(json['readBy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "date": date,
        "target": target,
        "readBy": readBy,
      };

  NotificationModel toDomain() => NotificationModel(
        id: id,
        title: title,
        body: body,
        date: date,
        target: target,
        readBy: readBy.map((key, value) => MapEntry(key, value as bool)),
      );
}
