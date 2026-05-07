import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/resume_provider.dart';
import '../../../core/utils/status_colors.dart';

class ResumeListScreen extends ConsumerWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes = ref.watch(resumeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resumes'),
      ),
      body: resumes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.note_add_outlined, size: 64, color: AppColors.accent),
                  ),
                  const SizedBox(height: 24),
                  const Text('No resumes found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  const Text('Create your first resume profile to get started.', style: TextStyle(color: AppColors.secondaryText)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/resumes/builder'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Resume'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: resumes.length,
              itemBuilder: (context, index) {
                final resume = resumes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () => context.push('/resumes/builder?id=${resume.id}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.description_outlined, color: AppColors.accent, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resume.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.update, size: 14, color: AppColors.secondaryText),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Updated ${DateFormat('MMM d, yyyy').format(resume.updatedAt)}',
                                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: AppColors.secondaryText),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onSelected: (value) {
                              if (value == 'edit') {
                                context.push('/resumes/builder?id=${resume.id}');
                              } else if (value == 'delete') {
                                _showDeleteDialog(context, ref, resume.id);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                                    SizedBox(width: 12),
                                    Text('Edit Profile'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, size: 20, color: AppColors.statusRejected),
                                    SizedBox(width: 12),
                                    Text('Delete', style: TextStyle(color: AppColors.statusRejected)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: resumes.isEmpty ? null : FloatingActionButton.extended(
        onPressed: () => context.push('/resumes/builder'),
        icon: const Icon(Icons.add),
        label: const Text('New Resume'),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Delete Resume?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('This action cannot be undone. Are you sure you want to delete this resume profile?'),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(resumeProvider.notifier).deleteResume(id);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Resume deleted'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusRejected),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
