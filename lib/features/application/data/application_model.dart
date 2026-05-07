import 'package:hive/hive.dart';

part 'application_model.g.dart';

@HiveType(typeId: 1)
class JobApplication extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String companyName;

  @HiveField(2)
  final String jobRole;

  @HiveField(3)
  final DateTime dateApplied;

  @HiveField(4)
  final String? resumeId; // Maps to Resume

  @HiveField(5)
  final String status;

  JobApplication({
    required this.id,
    required this.companyName,
    required this.jobRole,
    required this.dateApplied,
    this.resumeId,
    required this.status,
  });

  JobApplication copyWith({
    String? id,
    String? companyName,
    String? jobRole,
    DateTime? dateApplied,
    String? resumeId,
    String? status,
  }) {
    return JobApplication(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobRole: jobRole ?? this.jobRole,
      dateApplied: dateApplied ?? this.dateApplied,
      resumeId: resumeId ?? this.resumeId,
      status: status ?? this.status,
    );
  }
}
