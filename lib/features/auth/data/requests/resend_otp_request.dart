import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/payloads/resend_otp_payload.dart';

final class ResendOtpRequest extends RemoteRequest<ResendOtpPayload> {
  final String phoneNumber;

  ResendOtpRequest.fromPayload(super.payload)
      : phoneNumber = payload.phoneNumber,
        super.fromPayload();

  @override
  Json data() => {
        "phone_number": phoneNumber,
      };

  @override
  Map<String, String> path() => {};

  @override
  Map<String, String> query() => {};
}
