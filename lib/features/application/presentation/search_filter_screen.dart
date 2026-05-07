import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/application_provider.dart';
import '../../../core/utils/status_colors.dart';

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
    'Selected',
    'Rejected'
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
      appBar: AppBar(
        title: const Text('Search Applications'),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by company or role...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filterStatuses.map((status) {
                            final isSelected = _selectedFilterStatus == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(status),
                                selected: isSelected,
                                selectedColor: AppColors.accent,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                                backgroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedFilterStatus = status;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredApplications.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64, color: AppColors.border),
                      const SizedBox(height: 16),
                      const Text('No applications found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const SizedBox(height: 8),
                      Text('Try adjusting your search or filters.', style: TextStyle(color: AppColors.secondaryText)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredApplications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final app = filteredApplications[index];
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
          ),
        ],
      ),
    );
  }
}
