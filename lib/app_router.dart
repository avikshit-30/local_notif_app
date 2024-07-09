import 'package:go_router/go_router.dart';

import 'package:local_notif_app/features/splash_screen.dart';

import 'features/homepage.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/home",
      name: "home",
      builder: (context, state) => const MyHomePage(),
    ),
  ],
);
