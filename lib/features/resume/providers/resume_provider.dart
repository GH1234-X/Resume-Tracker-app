import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/resume_model.dart';

final resumeProvider = StateNotifierProvider<ResumeNotifier, List<Resume>>((ref) {
  return ResumeNotifier();
});

class ResumeNotifier extends StateNotifier<List<Resume>> {
  final Box<Resume> _box;

  ResumeNotifier() : _box = Hive.box<Resume>('resumes'), super([]) {
    _loadResumes();
  }

  void _loadResumes() {
    state = _box.values.toList();
  }

  void addResume(Resume resume) {
    _box.put(resume.id, resume);
    state = _box.values.toList();
  }

  void updateResume(Resume resume) {
    _box.put(resume.id, resume);
    state = _box.values.toList();
  }

  void deleteResume(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}
