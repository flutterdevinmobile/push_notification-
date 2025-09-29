import '../../../../shared/domain/domain.dart';

final class ResendOtpPayload extends Payload {
  final String phoneNumber;

  const ResendOtpPayload({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
      ];
}
