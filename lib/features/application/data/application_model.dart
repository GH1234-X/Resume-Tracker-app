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
  final String? resumeId;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String? userId;

  @HiveField(7)
  final bool isSynced;

  JobApplication({
    required this.id,
    required this.companyName,
    required this.jobRole,
    required this.dateApplied,
    this.resumeId,
    required this.status,
    this.userId,
    this.isSynced = false,
  });

  JobApplication copyWith({
    String? id,
    String? companyName,
    String? jobRole,
    DateTime? dateApplied,
    String? resumeId,
    String? status,
    String? userId,
    bool? isSynced,
  }) {
    return JobApplication(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobRole: jobRole ?? this.jobRole,
      dateApplied: dateApplied ?? this.dateApplied,
      resumeId: resumeId ?? this.resumeId,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
