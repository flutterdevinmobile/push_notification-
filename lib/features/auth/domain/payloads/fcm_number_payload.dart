import '../../../../shared/domain/domain.dart';

final class FcmNumberPayload extends Payload {
  final String fcmNumber;
  final String deviceToken;

  const FcmNumberPayload({
    required this.fcmNumber,
    required this.deviceToken,
  });

  @override
  List<String> get props => [
        "fcmNumber: $fcmNumber",
        "deviceToken: $deviceToken",
      ];
}
