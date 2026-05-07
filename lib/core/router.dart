import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/landing/presentation/landing_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/resume/presentation/resume_list_screen.dart';
import '../features/resume/presentation/resume_builder_screen.dart';
import '../features/application/presentation/job_application_entry_screen.dart';
import '../features/application/presentation/search_filter_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/landing' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // If logged in and on an auth page → send to dashboard
      if (isAuthenticated && isAuthRoute) return '/';

      // If not logged in and trying to access protected page → send to landing
      if (!isAuthenticated && !isAuthRoute) return '/landing';

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/resumes',
        builder: (context, state) => const ResumeListScreen(),
      ),
      GoRoute(
        path: '/resumes/builder',
        builder: (context, state) =>
            ResumeBuilderScreen(resumeId: state.uri.queryParameters['id']),
      ),
      GoRoute(
        path: '/applications/entry',
        builder: (context, state) =>
            JobApplicationEntryScreen(applicationId: state.uri.queryParameters['id']),
      ),
      GoRoute(
        path: '/applications/search',
        builder: (context, state) => const SearchFilterScreen(),
      ),
    ],
  );
});
