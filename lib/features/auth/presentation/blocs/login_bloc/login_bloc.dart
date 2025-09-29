import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/shared.dart';
import '../../../domain/models/login_model.dart';
import '../../../domain/payloads/login_payload.dart';
import '../../../domain/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;
  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<LoginStarted>(_onLoginStarted);
  }

  Future<void> _onLoginStarted(
    LoginStarted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInitial());
    emit(LoginPrepare());
    final result = await repository.login(
      payload: LoginPayload(
        phoneNumber: event.phoneNumber,
      ),
    );

    result.when(
      success: (model) => emit(
        LoginSuccess(model: model),
      ),
      failure: (error) => emit(
        LoginFailure(error: error),
      ),
    );
  }
}
