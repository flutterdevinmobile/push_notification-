import '../../../../shared/domain/domain.dart';

final class LoginModel extends Model {
  final String message;

  const LoginModel({required this.message});

  @override
  List<String> get props => [
        "messege: $message",
      ];
}
