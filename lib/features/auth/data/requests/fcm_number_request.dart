import 'package:rentify_nitification/features/auth/auth.dart';

import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';

final class FcmNumberRequest extends RemoteRequest<FcmNumberPayload> {
  final String fcmNumber;
  final String deviceToken;

  FcmNumberRequest.fromPayload(super.payload)
      : fcmNumber = payload.fcmNumber,
        deviceToken = payload.deviceToken,
        super.fromPayload();

  @override
  Json data() => {
        "deviceTokens": [deviceToken],
        "isActive": true,
      };

  @override
  Map<String, String> path() => {
        "collection": "users",
        "document": fcmNumber,
      };

  @override
  Map<String, String> query() => {};
}
