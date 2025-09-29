import '../../../../shared/domain/domain.dart';

final class VerifyOtpModel extends Model {
  final String token;
  final bool isNew;

  const VerifyOtpModel({required this.token, required this.isNew});

  @override
  List<String> get props => [
        "token: $token",
        "isNew: $isNew",
      ];
}
