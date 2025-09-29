part of 'resend_otp_bloc.dart';

sealed class ResendOtpEvent extends Equatable {
  const ResendOtpEvent();

  @override
  List<Object> get props => [];
}

final class ResendOtpStarted extends ResendOtpEvent {
  final String phoneNumber;

  const ResendOtpStarted({required this.phoneNumber});

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
      ];
}
