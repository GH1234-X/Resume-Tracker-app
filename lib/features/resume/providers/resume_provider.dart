import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../data/resume_model.dart';

final resumeProvider = StateNotifierProvider<ResumeNotifier, List<Resume>>((ref) {
  return ResumeNotifier();
});

class ResumeNotifier extends StateNotifier<List<Resume>> {
  ResumeNotifier() : super([]) {
    _loadResumes();
  }

  void _loadResumes() {
    // Phase 4 will use Hive
    // For now we will keep an empty list, but we can pre-populate if needed.
    state = [];
  }

  void addResume(Resume resume) {
    state = [...state, resume];
  }

  void updateResume(Resume resume) {
    state = [
      for (final r in state)
        if (r.id == resume.id) resume else r
    ];
  }

  void deleteResume(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}
