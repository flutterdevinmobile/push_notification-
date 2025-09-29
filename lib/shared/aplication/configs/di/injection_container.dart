import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../../../features/auth/data/repository/auth_repository_impl.dart';
import '../../../../features/auth/data/source/remote/auth_remote_source.dart';
import '../../../../features/auth/data/source/remote/fcm_remote_source.dart';
import '../../../../features/auth/domain/repository/auth_repository.dart';
import '../../../../features/auth/presentation/blocs/login_bloc/login_bloc.dart';
import '../../../../features/auth/presentation/blocs/resend_otp_bloc/resend_otp_bloc.dart';
import '../../../../features/auth/presentation/blocs/set_info_bloc/set_info_bloc.dart';
import '../../../../features/auth/presentation/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import '../../../../features/notification/data/repository/notification_repository_impl.dart';
import '../../../../features/notification/data/source/notification_source.dart';
import '../../../../features/notification/domain/repository/notification_repository.dart';
import '../../../../features/notification/presentation/blocs/notification_bloc/notification_bloc.dart';
import '../../../data/data.dart';
import '../logger/talker_logger.dart';

final sl = GetIt.instance;

Future<void> initDependencies(Box box) async {
  sl.registerSingleton(talker);

  sl.registerLazySingleton<Dio>(
    () => DioClient(
      hiveLocalSource: sl(),
      talker: sl(),
    ).createDioClient(),
  );

  sl.registerLazySingleton<HiveLocalSource>(() => HiveLocalSource(box));
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // === Auth sources ===
  sl.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSource(client: sl()),
  );
  sl.registerLazySingleton<FcmRemoteSource>(
    () => FcmRemoteSource(firestore: sl()),
  );

  // === Notification source ===
  sl.registerLazySingleton<NotificationRemoteSource>(
    () => NotificationRemoteSource(firestore: sl()),
  );

  // === Repositories ===
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl(),
      local: sl(),
      remoteFcm: sl(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remote: sl()),
  );

  // === Blocs ===
  sl.registerLazySingleton<LoginBloc>(() => LoginBloc(repository: sl()));
  sl.registerLazySingleton<VerifyOtpBloc>(
      () => VerifyOtpBloc(repository: sl()));
  sl.registerLazySingleton<ResendOtpBloc>(
      () => ResendOtpBloc(repository: sl()));
  sl.registerLazySingleton<SetInfoBloc>(() => SetInfoBloc(repository: sl()));

  sl.registerLazySingleton<NotificationBloc>(
    () => NotificationBloc(repository: sl()),
  );
}
