import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/application_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationProvider);
    
    final totalApplications = applications.length;
    
    final Map<String, int> statusDistribution = {};
    for (final app in applications) {
      statusDistribution[app.status] = (statusDistribution[app.status] ?? 0) + 1;
    }
    
    // Get top 5 recent applications (sort by date Applied)
    final recentApplications = List.from(applications)
      ..sort((a, b) => b.dateApplied.compareTo(a.dateApplied));
    final topRecent = recentApplications.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Application Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Resume Tracker',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('My Resumes'),
              onTap: () {
                context.pop();
                context.push('/resumes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Applications'),
              onTap: () {
                context.pop();
                context.push('/applications/search');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Applications', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('$totalApplications', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Status Distribution
            const Text('Status Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (statusDistribution.isEmpty)
              const Text('No applications yet.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: statusDistribution.entries.map((entry) {
                  return Chip(
                    label: Text('${entry.key}: ${entry.value}'),
                    backgroundColor: _getStatusColor(entry.key).withOpacity(0.2),
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 24),
            
            // Recent Applications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onHover: (hovering) {},
                  onPressed: () => context.push('/applications/entry'),
                  child: const Text('Add New'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (topRecent.isEmpty)
              const Center(child: Text('No recent applications'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topRecent.length,
                itemBuilder: (context, index) {
                  final app = topRecent[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(app.companyName),
                      subtitle: Text(app.jobRole),
                      trailing: Chip(
                        label: Text(app.status, style: const TextStyle(fontSize: 12)),
                        backgroundColor: _getStatusColor(app.status).withOpacity(0.2),
                      ),
                      onTap: () => context.push('/applications/entry?id=${app.id}'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/applications/entry'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Applied': return Colors.blue;
      case 'Shortlisted': return Colors.orange;
      case 'Interview Scheduled': return Colors.purple;
      case 'Rejected': return Colors.red;
      case 'Selected': return Colors.green;
      default: return Colors.grey;
    }
  }
}
