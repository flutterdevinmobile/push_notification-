import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/set_info_screen.dart';
import '../../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../../features/notification/presentation/screens/notification_screen.dart';
import '../../presentation/widgets/app_shell_scaffold.dart';
import 'logger/talker_logger.dart';

final routeObserver = TalkerRouteObserver(talker);
final rootNavigatorKey = GlobalKey<NavigatorState>();

final class AppRouterConfig {
  late final GoRouter router;

  AppRouterConfig() {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/login',
      observers: [routeObserver],
      routes: [
        GoRoute(
          name: "login",
          path: "/login",
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: "otp-code",
          path: "/verify-otp",
          builder: (context, state) {
            final phoneNumber = state.extra as String;
            return VerifyOtpScreen(phoneNumber: phoneNumber);
          },
        ),
        GoRoute(
          name: "set-info",
          path: "/set-info",
          builder: (context, state) => const SetInfoScreen(),
        ),
        GoRoute(
          name: "notification",
          path: "/notification",
          builder: (context, state) => const NotificationScreen(),
        ),

        /// Agar StatefulShell kerak bo‘lsa, shunaqa yoziladi:
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/home",
                  builder: (context, state) => const NotificationScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/profile",
                  builder: (context, state) => const SetInfoScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
