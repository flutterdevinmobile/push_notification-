part of 'resend_otp_bloc.dart';

sealed class ResendOtpState extends Equatable {
  const ResendOtpState();

  T when<T>({
    required T Function() initial,
    required T Function() inPrepare,
    required T Function(ResendOtpModel model) success,
    required T Function(BaseException error) failure,
  }) {
    return switch (this) {
      ResendOtpInitial() => initial(),
      ResendOtpPrepare() => inPrepare(),
      ResendOtpSuccess(:final model) => success(model),
      ResendOtpFailure(:final error) => failure(error),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? inPrepare,
    T Function(ResendOtpModel model)? success,
    T Function(BaseException)? failure,
    required T Function() orElse,
  }) {
    return when(
      initial: initial ?? orElse,
      inPrepare: inPrepare ?? orElse,
      failure: failure ?? (_) => orElse(),
      success: success ?? (_) => orElse(),
    );
  }

  T? whenOrNull<T>({
    T Function()? idle,
    T Function()? inPrepare,
    T Function(ResendOtpModel model)? success,
    T Function(BaseException error)? failure,
  }) {
    return maybeWhen(
      inPrepare: inPrepare,
      failure: failure,
      success: success,
      orElse: () => null,
    );
  }

  @override
  List<Object> get props => [];
}

final class ResendOtpInitial extends ResendOtpState {}

class ResendOtpPrepare extends ResendOtpState {}

class ResendOtpFailure extends ResendOtpState {
  final BaseException error;

  const ResendOtpFailure({required this.error});

  @override
  List<Object> get props => ["error: $error"];
}

class ResendOtpSuccess extends ResendOtpState {
  final ResendOtpModel model;

  const ResendOtpSuccess({required this.model});

  @override
  List<Object> get props => [
        "model: $model",
      ];
}
