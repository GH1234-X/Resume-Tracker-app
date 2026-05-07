import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/application_model.dart';

final applicationProvider = StateNotifierProvider<ApplicationNotifier, List<JobApplication>>((ref) {
  return ApplicationNotifier();
});

class ApplicationNotifier extends StateNotifier<List<JobApplication>> {
  ApplicationNotifier() : super([]) {
    _loadApplications();
  }

  void _loadApplications() {
    state = [];
  }

  void addApplication(JobApplication application) {
    state = [...state, application];
  }

  void updateApplication(JobApplication application) {
    state = [
      for (final a in state)
        if (a.id == application.id) application else a
    ];
  }

  void deleteApplication(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}
