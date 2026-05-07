import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'features/resume/data/resume_model.dart';
import 'features/application/data/application_model.dart';
import 'features/auth/data/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register all adapters
  Hive.registerAdapter(ResumeAdapter());
  Hive.registerAdapter(JobApplicationAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // Open all boxes (clear old incompatible data on schema changes)
  await Hive.openBox<Resume>('resumes');
  await Hive.openBox<JobApplication>('applications');
  await Hive.openBox<UserModel>('users');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'ResumeTrack',
      theme: appTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
