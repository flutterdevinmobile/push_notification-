import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/aplication/exceptions/exceptions.dart';
import '../../../domain/models/resend_otp_model.dart';
import '../../../domain/payloads/resend_otp_payload.dart';
import '../../../domain/repository/auth_repository.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  final AuthRepository repository;
  ResendOtpBloc({required this.repository}) : super(ResendOtpInitial()) {
    on<ResendOtpStarted>(_onResendOtpStarted);
  }

  Future<void> _onResendOtpStarted(
    ResendOtpStarted event,
    Emitter<ResendOtpState> emit,
  ) async {
    emit(ResendOtpInitial());
    emit(ResendOtpPrepare());
    final result = await repository.resendOtp(
      payload: ResendOtpPayload(phoneNumber: event.phoneNumber),
    );

    result.when(
      success: (model) => emit(
        ResendOtpSuccess(model: model),
      ),
      failure: (error) => emit(
        ResendOtpFailure(error: error),
      ),
    );
  }
}
