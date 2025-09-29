import '../../../../shared/aplication/types/json.dart';
import '../../../../shared/data/data.dart';
import '../../domain/models/login_model.dart';

final class LoginDto extends JsonDto<LoginModel> {
  final Json json;
  String get message => json["message"];
  LoginDto.fromJson(this.json) : super.fromJson(json);
  @override
  LoginModel model() {
    return LoginModel(message: message);
  }
}
