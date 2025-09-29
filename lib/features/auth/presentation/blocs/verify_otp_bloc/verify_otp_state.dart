part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  T when<T>({
    required T Function() initial,
    required T Function() inPrepare,
    required T Function(VerifyOtpModel model) success,
    required T Function(BaseException error) failure,
  }) {
    return switch (this) {
      VerifyOtpInitial() => initial(),
      VerifyOtpPrepare() => inPrepare(),
      VerifyOtpSuccess(:final model) => success(model),
      VerifyOtpFailure(:final error) => failure(error),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? inPrepare,
    T Function(VerifyOtpModel model)? success,
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
    T Function(VerifyOtpModel model)? success,
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

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpPrepare extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {
  final VerifyOtpModel model;

  const VerifyOtpSuccess({
    required this.model,
  });

  @override
  List<Object> get props => [
        "model: $model",
      ];
}

final class VerifyOtpFailure extends VerifyOtpState {
  final BaseException error;

  const VerifyOtpFailure({required this.error});

  @override
  List<Object> get props => [
        "error: $error",
      ];
}
