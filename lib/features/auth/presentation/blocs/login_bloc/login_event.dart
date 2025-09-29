part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginStarted extends LoginEvent {
  final String phoneNumber;

  const LoginStarted({required this.phoneNumber});

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
      ];
}
