import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/models/resend_otp_model.dart';

final class ResendOtpDto extends JsonDto<ResendOtpModel> {
  final Json json;

  String get message => json["message"];

  ResendOtpDto.fromJson(this.json) : super.fromJson(json);

  @override
  ResendOtpModel model() {
    return ResendOtpModel(message: message);
  }
}
