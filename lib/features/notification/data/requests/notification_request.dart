import 'package:rentify_nitification/shared/data/data.dart';

import '../../../../shared/aplication/types/json.dart';
import '../../domain/payloads/notification_payload.dart';

final class NotificationRequest extends RemoteRequest {
  final String target;

  NotificationRequest({
    required this.target,
  }) : super.fromPayload(NotificationPayload(target: target));

  factory NotificationRequest.fromPayload(NotificationPayload payload) {
    return NotificationRequest(target: payload.target);
  }

  @override
  List<String> get props => ["target: $target"];

  @override
  Json data() => {};

  @override
  Map<String, String> path() => {};

  @override
  Map<String, String> query() => {"target": target};
}
