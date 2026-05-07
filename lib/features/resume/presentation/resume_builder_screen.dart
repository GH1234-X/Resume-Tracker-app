import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../data/resume_model.dart';

class ResumeBuilderScreen extends ConsumerStatefulWidget {
  final String? resumeId;
  const ResumeBuilderScreen({super.key, this.resumeId});

  @override
  ConsumerState<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends ConsumerState<ResumeBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();

  Resume? _existingResume;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resumeId != null) {
        final resumes = ref.read(resumeProvider);
        try {
          _existingResume = resumes.firstWhere((r) => r.id == widget.resumeId);
          _nameController.text = _existingResume!.name;
          _emailController.text = _existingResume!.email;
          _phoneController.text = _existingResume!.phone;
          _educationController.text = _existingResume!.education;
          _skillsController.text = _existingResume!.skills;
          _experienceController.text = _existingResume!.experience ?? '';
        } catch (e) {
          // Resume not found
        }
      }
    });
  }

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
      final resume = Resume(
        id: _existingResume?.id ?? const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        education: _educationController.text,
        skills: _skillsController.text,
        experience: _experienceController.text.isNotEmpty ? _experienceController.text : null,
        updatedAt: DateTime.now(),
      );

      if (_existingResume != null) {
        ref.read(resumeProvider.notifier).updateResume(resume);
      } else {
        ref.read(resumeProvider.notifier).addResume(resume);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume Saved')),
      );
      context.pop();
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
