import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/application_model.dart';

final applicationProvider = StateNotifierProvider<ApplicationNotifier, List<JobApplication>>((ref) {
  return ApplicationNotifier();
});

class ApplicationNotifier extends StateNotifier<List<JobApplication>> {
  final Box<JobApplication> _box;

  ApplicationNotifier() : _box = Hive.box<JobApplication>('applications'), super([]) {
    _loadApplications();
  }

  void _loadApplications() {
    state = _box.values.toList();
  }

  void addApplication(JobApplication application) {
    _box.put(application.id, application);
    state = _box.values.toList();
  }

  void updateApplication(JobApplication application) {
    _box.put(application.id, application);
    state = _box.values.toList();
  }

  void deleteApplication(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}
