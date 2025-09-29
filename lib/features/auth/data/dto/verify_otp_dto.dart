import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/models/verify_otp_model.dart';

final class VerifyOtpDto extends JsonDto<VerifyOtpModel> {
  final Json json;

  VerifyOtpDto.fromJson(this.json) : super.fromJson(json);
  String get token => json["token"];
  bool get isNew => json["isNew"];
  @override
  VerifyOtpModel model() {
    return VerifyOtpModel(token: token, isNew: isNew);
  }
}
