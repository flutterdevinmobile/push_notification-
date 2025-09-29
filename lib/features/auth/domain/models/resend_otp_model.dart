import '../../../../shared/domain/domain.dart';

final class ResendOtpModel extends Model {
  final String message;

  const ResendOtpModel({required this.message});

  @override
  List<String> get props => [
        "messege: $message",
      ];
}
