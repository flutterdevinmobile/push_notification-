import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/payloads/verify_otp_payload.dart';

final class VerifyOtpRequest extends RemoteRequest<VerifyOtpPayload> {
  final String otpCode;
  final String phoneNumber;
  final String? lang;
  VerifyOtpRequest.fromPayload(super.payload)
      : otpCode = payload.otpCode,
        phoneNumber = payload.phoneNumber,
        lang = payload.lang,
        super.fromPayload();

  @override
  Json data() => {
        "phone_number": phoneNumber,
        "otp_code": otpCode,
        "lang": lang,
      };

  @override
  Map<String, String> path() => {};
  @override
  Map<String, String> query() => {};
}
