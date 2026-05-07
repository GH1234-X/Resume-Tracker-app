import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dashboard Placeholder'),
            ElevatedButton(
              onPressed: () => context.push('/resumes'),
              child: const Text('Manage Resumes'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/applications/entry'),
              child: const Text('Add Application'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/applications/search'),
              child: const Text('Search Applications'),
            ),
          ],
        ),
      ),
    );
  }
}
