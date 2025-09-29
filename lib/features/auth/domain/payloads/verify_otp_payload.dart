import '../../../../shared/domain/domain.dart';

final class VerifyOtpPayload extends Payload {
  final String phoneNumber;
  final String otpCode;
  final String? lang;

  const VerifyOtpPayload({
    required this.phoneNumber,
    required this.otpCode,
    required this.lang,
  });

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
        "otpCode: $otpCode",
        "lang: $lang",
      ];
}
