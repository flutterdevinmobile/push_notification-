import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/notification_model.dart';
import '../../../domain/repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  StreamSubscription<List<NotificationModel>>? _subscription;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationMarkedAsRead>(_onMarkedAsRead);
    on<EmitNotifications>(_onEmitNotifications); // 🔑 endi ishlaydi
  }

  Future<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    await _subscription?.cancel();
    _subscription =
        repository.listenNotifications(target: "all").listen((notifications) {
      add(EmitNotifications(notifications));
    });
  }

  Future<void> _onMarkedAsRead(
    NotificationMarkedAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await repository.markAsRead(
      notificationId: event.notificationId,
      fcmNumber: event.fcmNumber,
    );
  }

  void _onEmitNotifications(
    EmitNotifications event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationLoaded(event.notifications));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
