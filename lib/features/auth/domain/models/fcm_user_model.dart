import '../../../../shared/domain/domain.dart';

final class FcmUserModel extends Model {
  final List<String> deviceTokens;
  final bool isActive;
  const FcmUserModel({
    required this.deviceTokens,
    required this.isActive,
  });
  @override
  List<String> get props => [
        "deviceTokens: $deviceTokens",
        "isActive: $isActive",
      ];
}
