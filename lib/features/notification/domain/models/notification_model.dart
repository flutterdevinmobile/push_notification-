class NotificationModel {
  final String id; // firestore document id
  final String title;
  final String body;
  final DateTime date;
  final String target;
  final Map<String, bool> readBy;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.target,
    required this.readBy,
  });
}
