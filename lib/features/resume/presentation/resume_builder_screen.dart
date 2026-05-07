import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../data/resume_model.dart';
import '../../../core/utils/status_colors.dart';

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
        SnackBar(
          content: const Text('Resume Saved Successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 32.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resumeId == null ? 'Create Resume' : 'Edit Resume'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Save'),
              onPressed: _saveResume,
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
                    const Text('Basic Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 1.0)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', hintText: 'John Doe'),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email Address', hintText: 'john@example.com'),
                            validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+1 234 567 890'),
                            validator: (value) => value == null || value.isEmpty ? 'Please enter phone' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Education', Icons.school_outlined),
                    TextFormField(
                      controller: _educationController,
                      decoration: const InputDecoration(
                        labelText: 'Degree & University',
                        hintText: 'e.g., B.S. in Computer Science, Stanford University',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter education details' : null,
                    ),
                    
                    _buildSectionTitle('Skills', Icons.psychology_outlined),
                    TextFormField(
                      controller: _skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Core Skills',
                        hintText: 'e.g., Flutter, Dart, Riverpod, Firebase',
                        helperText: 'Separate skills with commas',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter skills' : null,
                    ),
                    
                    _buildSectionTitle('Experience (Optional)', Icons.work_history_outlined),
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: 'Work Experience',
                        hintText: 'Describe your past roles, companies, and achievements...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
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
            onPressed: _saveResume,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Save Resume Profile'),
          ),
        ),
      ),
    );
  }
}
