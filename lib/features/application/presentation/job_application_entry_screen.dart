import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/application_provider.dart';
import '../data/application_model.dart';
import '../../resume/providers/resume_provider.dart';
import '../../../core/utils/status_colors.dart';

class JobApplicationEntryScreen extends ConsumerStatefulWidget {
  final String? applicationId;
  const JobApplicationEntryScreen({super.key, this.applicationId});

  @override
  ConsumerState<JobApplicationEntryScreen> createState() => _JobApplicationEntryScreenState();
}

class _JobApplicationEntryScreenState extends ConsumerState<JobApplicationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  DateTime _dateApplied = DateTime.now();
  String _selectedStatus = 'Applied';
  String? _selectedResumeId;

  JobApplication? _existingApplication;

  final List<String> _statuses = [
    'Applied',
    'Shortlisted',
    'Interview Scheduled',
    'Selected',
    'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.applicationId != null) {
        final apps = ref.read(applicationProvider);
        try {
          _existingApplication = apps.firstWhere((a) => a.id == widget.applicationId);
          _companyController.text = _existingApplication!.companyName;
          _roleController.text = _existingApplication!.jobRole;
          _dateApplied = _existingApplication!.dateApplied;
          _selectedStatus = _existingApplication!.status;
          _selectedResumeId = _existingApplication!.resumeId;
          setState(() {});
        } catch (e) {
          // Not found
        }
      }
    });
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateApplied,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateApplied) {
      setState(() {
        _dateApplied = picked;
      });
    }
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final app = JobApplication(
        id: _existingApplication?.id ?? const Uuid().v4(),
        companyName: _companyController.text,
        jobRole: _roleController.text,
        dateApplied: _dateApplied,
        resumeId: _selectedResumeId,
        status: _selectedStatus,
      );

      if (_existingApplication != null) {
        ref.read(applicationProvider.notifier).updateApplication(app);
      } else {
        ref.read(applicationProvider.notifier).addApplication(app);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Application Logged Successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 24.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumes = ref.watch(resumeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.applicationId == null ? 'Log Application' : 'Edit Application'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Save'),
              onPressed: _saveApplication,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppColors.surface,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('JOB DETAILS'),
                    TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(labelText: 'Company Name', hintText: 'e.g., Google'),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter company name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _roleController,
                      decoration: const InputDecoration(labelText: 'Job Role', hintText: 'e.g., Senior Software Engineer'),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter job role' : null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('APPLICATION STATUS'),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Date Applied', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMMM d, yyyy').format(_dateApplied),
                                  style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const Icon(Icons.calendar_today_outlined, color: AppColors.accent),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Current Status'),
                      value: _selectedStatus,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                      items: _statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(status, style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                    
                    _buildSectionTitle('LINKED RESUME'),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Resume Used (Optional)'),
                      value: _selectedResumeId,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None / Default')),
                        ...resumes.map((resume) {
                          return DropdownMenuItem(
                            value: resume.id,
                            child: Text(resume.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedResumeId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: _saveApplication,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Save Application'),
          ),
        ),
      ),
    );
  }
}
