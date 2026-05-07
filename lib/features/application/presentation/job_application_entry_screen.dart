import 'package:flutter/material.dart';

class JobApplicationEntryScreen extends StatelessWidget {
  final String? applicationId;
  const JobApplicationEntryScreen({super.key, this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(applicationId == null ? 'Add Application' : 'Edit Application')),
      body: const Center(child: Text('Job Application Entry Placeholder')),
    );
  }
}
