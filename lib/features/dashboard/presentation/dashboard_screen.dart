import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../application/providers/application_provider.dart';
import '../../../core/utils/status_colors.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    final totalApplications = applications.length;
    
    final Map<String, int> statusDistribution = {};
    for (final app in applications) {
      statusDistribution[app.status] = (statusDistribution[app.status] ?? 0) + 1;
    }
    
    final recentApplications = List.from(applications)
      ..sort((a, b) => b.dateApplied.compareTo(a.dateApplied));
    final topRecent = recentApplications.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.accent.withOpacity(0.15),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Text(user.email, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go('/landing');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: AppColors.statusRejected),
                        SizedBox(width: 10),
                        Text('Sign out', style: TextStyle(color: AppColors.statusRejected)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.background,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work_outline, color: AppColors.accent, size: 24),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Resume Tracker',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    const Text('Manage your career', style: TextStyle(color: AppColors.secondaryText)),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 16),
              _buildDrawerItem(context, Icons.dashboard_outlined, 'Dashboard', () => context.pop()),
              _buildDrawerItem(context, Icons.description_outlined, 'My Resumes', () {
                context.pop();
                context.push('/resumes');
              }),
              _buildDrawerItem(context, Icons.search_outlined, 'Search Applications', () {
                context.pop();
                context.push('/applications/search');
              }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Your Activity',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 24),

            // Main Stat Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Applications',
                        style: TextStyle(fontSize: 16, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.trending_up, color: AppColors.accent.withOpacity(0.8), size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$totalApplications',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Status Distribution
            const Text('Status Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (statusDistribution.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('No applications yet.', style: TextStyle(color: AppColors.secondaryText)),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: statusDistribution.entries.map((entry) {
                  final bgColor = AppColors.getStatusColor(entry.key);
                  final textColor = AppColors.getStatusTextColor(entry.key);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: bgColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${entry.key}',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${entry.value}',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            // Recent Applications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () => context.push('/applications/entry'),
                  child: const Text('Add New'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (topRecent.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: AppColors.border),
                    SizedBox(height: 16),
                    Text('No recent applications', style: TextStyle(color: AppColors.secondaryText)),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topRecent.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final app = topRecent[index];
                  final bgColor = AppColors.getStatusColor(app.status);
                  final textColor = AppColors.getStatusTextColor(app.status);
                  
                  return InkWell(
                    onTap: () => context.push('/applications/entry?id=${app.id}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                app.companyName.isNotEmpty ? app.companyName[0].toUpperCase() : '?',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.companyName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  app.jobRole,
                                  style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: bgColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  app.status,
                                  style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('MMM d').format(app.dateApplied),
                                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/applications/entry'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryText),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
