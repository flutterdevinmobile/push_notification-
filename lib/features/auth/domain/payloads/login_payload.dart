import '../../../../shared/domain/domain.dart';

final class LoginPayload extends Payload {
  final String phoneNumber;
  const LoginPayload({required this.phoneNumber});

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
      ];
}
