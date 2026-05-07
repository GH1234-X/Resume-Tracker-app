import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobApplicationEntryScreen extends StatefulWidget {
  final String? applicationId;
  const JobApplicationEntryScreen({super.key, this.applicationId});

  @override
  State<JobApplicationEntryScreen> createState() => _JobApplicationEntryScreenState();
}

class _JobApplicationEntryScreenState extends State<JobApplicationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  DateTime _dateApplied = DateTime.now();
  String _selectedStatus = 'Applied';
  String? _selectedResumeId;

  // Mock statuses
  final List<String> _statuses = [
    'Applied',
    'Shortlisted',
    'Interview Scheduled',
    'Rejected',
    'Selected'
  ];

  // Mock resumes
  final List<Map<String, String>> _mockResumes = [
    {'id': '1', 'name': 'Software Engineer Resume'},
    {'id': '2', 'name': 'Product Manager Resume'},
  ];

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
    );
    if (picked != null && picked != _dateApplied) {
      setState(() {
        _dateApplied = picked;
      });
    }
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job Application Saved (Mock)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.applicationId == null ? 'Add Application' : 'Edit Application'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveApplication,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter company name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Job Role'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter job role' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date Applied'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_dateApplied)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: _selectedStatus,
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Resume Used (Optional)'),
                value: _selectedResumeId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ..._mockResumes.map((resume) {
                    return DropdownMenuItem(
                      value: resume['id'],
                      child: Text(resume['name']!),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedResumeId = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveApplication,
                  child: const Text('Save Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
