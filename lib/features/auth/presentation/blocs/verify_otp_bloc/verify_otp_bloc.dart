import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/aplication/exceptions/exceptions.dart';
import '../../../domain/models/verify_otp_model.dart';
import '../../../domain/payloads/verify_otp_payload.dart';
import '../../../domain/repository/auth_repository.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final AuthRepository repository;
  VerifyOtpBloc({required this.repository}) : super(VerifyOtpInitial()) {
    on<VerifyOtpStarted>(_onVerifyOtpStarted);
  }

  Future<void> _onVerifyOtpStarted(
    VerifyOtpStarted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpInitial());
    emit(VerifyOtpPrepare());
    final result = await repository.verifyOtp(
      payload: VerifyOtpPayload(
        phoneNumber: event.phoneNumber,
        otpCode: event.otpCode,
        lang: event.lang,
      ),
    );

    result.when(
      success: (model) => emit(
        VerifyOtpSuccess(model: model),
      ),
      failure: (error) => emit(
        VerifyOtpFailure(error: error),
      ),
    );
  }
}
