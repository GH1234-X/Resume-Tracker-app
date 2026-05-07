import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: const Center(child: Text('Resume List Placeholder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/resumes/builder'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
