import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for UI presentation
    final mockResumes = [
      {'id': '1', 'name': 'Software Engineer Resume', 'updatedAt': '2026-05-01'},
      {'id': '2', 'name': 'Product Manager Resume', 'updatedAt': '2026-05-05'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: mockResumes.isEmpty
          ? const Center(child: Text('No resumes found. Create one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: mockResumes.length,
              itemBuilder: (context, index) {
                final resume = mockResumes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.description),
                    ),
                    title: Text(resume['name']!),
                    subtitle: Text('Last updated: ${resume['updatedAt']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => context.push('/resumes/builder?id=${resume['id']}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Delete clicked (Mock)')),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => context.push('/resumes/builder?id=${resume['id']}'),
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
