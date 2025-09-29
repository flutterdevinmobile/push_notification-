import '../../../../shared/shared.dart';
import '../../domain/models/set_info_model.dart';

final class SetInfoDto extends JsonDto<SetInfoModel> {
  final Json json;

  String get message => json["message"];

  SetInfoDto.fromJson(this.json) : super.fromJson(json);

  @override
  SetInfoModel model() {
    return SetInfoModel(
      message: message,
    );
  }
}
