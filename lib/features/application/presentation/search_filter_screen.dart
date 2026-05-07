import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
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

  // Mock Data
  final List<Map<String, String>> _allApplications = [
    {'company': 'Google', 'role': 'Software Engineer', 'status': 'Interview Scheduled', 'date': '2026-05-01'},
    {'company': 'Meta', 'role': 'Frontend Developer', 'status': 'Applied', 'date': '2026-05-02'},
    {'company': 'Amazon', 'role': 'Backend Engineer', 'status': 'Shortlisted', 'date': '2026-05-03'},
    {'company': 'Apple', 'role': 'iOS Developer', 'status': 'Rejected', 'date': '2026-04-20'},
  ];

  List<Map<String, String>> _filteredApplications = [];

  @override
  void initState() {
    super.initState();
    _filteredApplications = _allApplications;
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApplications = _allApplications.where((app) {
        final matchesSearch = app['company']!.toLowerCase().contains(query) || 
                              app['role']!.toLowerCase().contains(query);
        final matchesStatus = _selectedFilterStatus == 'All' || app['status'] == _selectedFilterStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            _filterData();
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
            child: ListView.builder(
              itemCount: _filteredApplications.length,
              itemBuilder: (context, index) {
                final app = _filteredApplications[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.work)),
                  title: Text(app['company']!),
                  subtitle: Text('${app['role']} • ${app['date']}'),
                  trailing: Chip(
                    label: Text(app['status']!, style: const TextStyle(fontSize: 12)),
                    backgroundColor: _getStatusColor(app['status']!).withOpacity(0.2),
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
