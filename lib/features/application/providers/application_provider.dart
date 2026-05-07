import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/application_model.dart';

final applicationProvider = NotifierProvider<ApplicationNotifier, List<JobApplication>>(ApplicationNotifier.new);

class ApplicationNotifier extends Notifier<List<JobApplication>> {
  late final Box<JobApplication> _box;

  @override
  List<JobApplication> build() {
    _box = Hive.box<JobApplication>('applications');
    return _box.values.toList();
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
