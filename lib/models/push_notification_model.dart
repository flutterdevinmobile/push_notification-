import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class PushNotificationModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? body;

  @HiveField(3)
  Map<String, dynamic>? data;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  bool isRead;

  PushNotificationModel({
    required this.id,
    this.title,
    this.body,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });
}

class PushNotificationModelAdapter extends TypeAdapter<PushNotificationModel> {
  @override
  final int typeId = 0;

  @override
  PushNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PushNotificationModel(
      id: fields[0] as String,
      title: fields[1] as String?,
      body: fields[2] as String?,
      data: (fields[3] as Map?)?.cast<String, dynamic>(),
      timestamp: fields[4] as DateTime,
      isRead: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PushNotificationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isRead);
  }
}
