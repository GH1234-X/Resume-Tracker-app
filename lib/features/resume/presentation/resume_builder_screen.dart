import 'package:flutter/material.dart';

class ResumeBuilderScreen extends StatelessWidget {
  final String? resumeId;
  const ResumeBuilderScreen({super.key, this.resumeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(resumeId == null ? 'Create Resume' : 'Edit Resume')),
      body: const Center(child: Text('Resume Builder Placeholder')),
    );
  }
}
