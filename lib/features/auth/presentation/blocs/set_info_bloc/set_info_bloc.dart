import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/aplication/exceptions/exceptions.dart';
import '../../../domain/models/set_info_model.dart';
import '../../../domain/payloads/set_info_payload.dart';
import '../../../domain/repository/auth_repository.dart';

part 'set_info_event.dart';
part 'set_info_state.dart';

class SetInfoBloc extends Bloc<SetInfoEvent, SetInfoState> {
  final AuthRepository repository;
  SetInfoBloc({required this.repository}) : super(SetInfoInitial()) {
    on<SetInfoStarted>(_onSetInfoStarted);
  }
  Future<void> _onSetInfoStarted(
    SetInfoStarted event,
    Emitter<SetInfoState> emit,
  ) async {
    emit(SetInfoInitial());

    emit(SetInfoPrepare());

    final result = await repository.setInfo(
      payload: SetInfoPayload(
        description: event.description,
        name: event.name,
      ),
    );

    result.when(
      success: (model) => emit(
        SetInfoSuccess(model: model),
      ),
      failure: (error) => emit(
        SetInfoFailure(error: error),
      ),
    );
  }
}
