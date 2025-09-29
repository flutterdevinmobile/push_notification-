import 'package:rentify_nitification/shared/data/data.dart';

import '../../../../shared/aplication/types/json.dart';
import '../../domain/models/fcm_user_model.dart';

final class FcmUserDto extends JsonDto<FcmUserModel> {
  final Json json;

  List<String> get deviceTokens =>
      (json["deviceTokens"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
      [];

  bool get isActive => json["isActive"] ?? true;

  FcmUserDto.fromJson(this.json) : super.fromJson(json);

  @override
  FcmUserModel model() {
    return FcmUserModel(
      deviceTokens: deviceTokens,
      isActive: isActive,
    );
  }
}
