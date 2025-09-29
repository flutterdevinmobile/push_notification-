import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/payloads/set_info_payload.dart';

final class SetInfoRequest extends RemoteRequest<SetInfoPayload> {
  final String name;
  final String? description;
  SetInfoRequest.fromPayload(super.payload)
      : name = payload.name,
        description = payload.description,
        super.fromPayload();

  @override
  Json data() => {
        "name": name,
        "description": description,
      };
  @override
  Map<String, String> path() => {};

  @override
  Map<String, String> query() => {};
}
