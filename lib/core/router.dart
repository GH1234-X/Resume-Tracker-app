import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/resume/presentation/resume_list_screen.dart';
import '../features/resume/presentation/resume_builder_screen.dart';
import '../features/application/presentation/job_application_entry_screen.dart';
import '../features/application/presentation/search_filter_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
      builder: (context, state) => ResumeBuilderScreen(resumeId: state.uri.queryParameters['id']),
    ),
    GoRoute(
      path: '/applications/entry',
      builder: (context, state) => JobApplicationEntryScreen(applicationId: state.uri.queryParameters['id']),
    ),
    GoRoute(
      path: '/applications/search',
      builder: (context, state) => const SearchFilterScreen(),
    ),
  ],
);
