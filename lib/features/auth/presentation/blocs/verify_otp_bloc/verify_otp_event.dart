part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

final class VerifyOtpStarted extends VerifyOtpEvent {
  final String phoneNumber;
  final String otpCode;
  final String? lang;

  const VerifyOtpStarted({
    required this.phoneNumber,
    required this.otpCode,
    required this.lang,
  });

  @override
  List<Object> get props => [
        "phoneNumber: $phoneNumber",
        "otpCode: $otpCode",
        "lang: $lang",
      ];
}
