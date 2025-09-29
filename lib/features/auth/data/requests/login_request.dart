import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/payloads/login_payload.dart';

final class LoginRequest extends RemoteRequest<LoginPayload> {
  final String phoneNumber;
  LoginRequest.fromPayload(
    super.payload,
  )   : phoneNumber = payload.phoneNumber,
        super.fromPayload();

  @override
  Json data() => {"phone_number": phoneNumber};

  @override
  Map<String, String> path() => {};

  @override
  Map<String, String> query() => {};
}
