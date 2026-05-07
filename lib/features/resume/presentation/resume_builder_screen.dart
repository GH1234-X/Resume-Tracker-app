import 'package:flutter/material.dart';

class ResumeBuilderScreen extends StatefulWidget {
  final String? resumeId;
  const ResumeBuilderScreen({super.key, this.resumeId});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _saveResume() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume Saved (Mock)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resumeId == null ? 'Create Resume' : 'Edit Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveResume,
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
              const Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter phone' : null,
              ),
              const SizedBox(height: 24),
              const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(labelText: 'Degree & University'),
                maxLines: 2,
                validator: (value) => value == null || value.isEmpty ? 'Please enter education' : null,
              ),
              const SizedBox(height: 24),
              const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(labelText: 'Skills (comma separated)'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter skills' : null,
              ),
              const SizedBox(height: 24),
              const Text('Experience (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Work Experience'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveResume,
                  child: const Text('Save Resume'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
