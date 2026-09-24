import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/actions/actions_screen.dart';
import '../screens/campaigns/campaigns_screen.dart';
import '../screens/campaigns/create/create_campaign_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/home/dashboard_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/more/more_screen.dart';
import '../screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/chat',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/home/campaigns/create',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CreateCampaignScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home/dashboard', builder: (context, state) => const DashboardScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home/insights', builder: (context, state) => const InsightsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home/actions', builder: (context, state) => const ActionsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home/campaigns', builder: (context, state) => const CampaignsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home/more', builder: (context, state) => const MoreScreen())],
        ),
      ],
    ),
  ],
);
