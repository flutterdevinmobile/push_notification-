import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rentify_nitification/shared/aplication/configs/di/injection_container.dart';
import 'package:rentify_nitification/shared/aplication/configs/logger/talker_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';

import 'app.dart';
import 'features/auth/presentation/blocs/login_bloc/login_bloc.dart';
import 'features/auth/presentation/blocs/resend_otp_bloc/resend_otp_bloc.dart';
import 'features/auth/presentation/blocs/set_info_bloc/set_info_bloc.dart';
import 'features/auth/presentation/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'features/notification/presentation/blocs/notification_bloc/notification_bloc.dart';

void main() async {
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printCreations: true,
      printClosings: true,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Android
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // iOS
    ),
  );

  await Future.wait([
    Firebase.initializeApp(),
    Hive.initFlutter(),
    EasyLocalization.ensureInitialized(),
  ]);

  final box = await Hive.openBox('authBox');

  await initDependencies(box);

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('ru'),
          Locale('uz'),
          Locale('en'),
        ],
        path: 'assets/langs',
        fallbackLocale: Locale('ru'),
        startLocale: Locale('ru'),
        saveLocale: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<LoginBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<VerifyOtpBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<ResendOtpBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<SetInfoBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<NotificationBloc>(),
            ),
          ],
          child: MyApp(),
        )),
  );
}
