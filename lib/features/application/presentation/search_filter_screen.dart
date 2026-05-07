import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/application_provider.dart';
import '../data/application_model.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final _searchController = TextEditingController();
  String _selectedFilterStatus = 'All';

  final List<String> _filterStatuses = [
    'All',
    'Applied',
    'Shortlisted',
    'Interview Scheduled',
    'Rejected',
    'Selected'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationProvider);
    final query = _searchController.text.toLowerCase();

    final filteredApplications = applications.where((app) {
      final matchesSearch = app.companyName.toLowerCase().contains(query) || 
                            app.jobRole.toLowerCase().contains(query);
      final matchesStatus = _selectedFilterStatus == 'All' || app.status == _selectedFilterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Company or Role',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Filter by Status: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilterStatus,
                        items: _filterStatuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFilterStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredApplications.isEmpty 
              ? const Center(child: Text('No applications found'))
              : ListView.builder(
                  itemCount: filteredApplications.length,
                  itemBuilder: (context, index) {
                    final app = filteredApplications[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.work)),
                      title: Text(app.companyName),
                      subtitle: Text('${app.jobRole} • ${DateFormat('yyyy-MM-dd').format(app.dateApplied)}'),
                      trailing: Chip(
                        label: Text(app.status, style: const TextStyle(fontSize: 12)),
                        backgroundColor: _getStatusColor(app.status).withOpacity(0.2),
                      ),
                    );
                  },
                ),
          ),
        ],
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
