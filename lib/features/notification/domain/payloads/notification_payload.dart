import 'package:rentify_nitification/shared/shared.dart';

final class NotificationPayload extends Payload {
  final String target;

  const NotificationPayload({
    required this.target,
  });

  @override
  List<String> get props => [
        "target: $target",
      ];
}
