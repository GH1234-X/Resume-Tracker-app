import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/resume_provider.dart';

class ResumeListScreen extends ConsumerWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes = ref.watch(resumeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: resumes.isEmpty
          ? const Center(child: Text('No resumes found. Create one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: resumes.length,
              itemBuilder: (context, index) {
                final resume = resumes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.description),
                    ),
                    title: Text(resume.name),
                    subtitle: Text('Last updated: ${DateFormat('yyyy-MM-dd').format(resume.updatedAt)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => context.push('/resumes/builder?id=${resume.id}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(resumeProvider.notifier).deleteResume(resume.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Resume deleted')),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => context.push('/resumes/builder?id=${resume.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resumes/builder'),
        icon: const Icon(Icons.add),
        label: const Text('Create Resume'),
      ),
    );
  }
}
