part of 'set_info_bloc.dart';

sealed class SetInfoState extends Equatable {
  const SetInfoState();

  T when<T>({
    required T Function() initial,
    required T Function() inPrepare,
    required T Function(SetInfoModel model) success,
    required T Function(BaseException error) failure,
  }) {
    return switch (this) {
      SetInfoInitial() => initial(),
      SetInfoPrepare() => inPrepare(),
      SetInfoSuccess(:final model) => success(model),
      SetInfoFailure(:final error) => failure(error),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? inPrepare,
    T Function(SetInfoModel model)? success,
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
    T Function(SetInfoModel model)? success,
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

final class SetInfoPrepare extends SetInfoState {}

final class SetInfoInitial extends SetInfoState {}

class SetInfoSuccess extends SetInfoState {
  final SetInfoModel model;

  const SetInfoSuccess({required this.model});

  @override
  List<Object> get props => ["model: $model"];
}

final class SetInfoFailure extends SetInfoState {
  final BaseException error;

  const SetInfoFailure({required this.error});

  @override
  List<Object> get props => ["error: $error"];
}
