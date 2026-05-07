import 'package:hive/hive.dart';

part 'resume_model.g.dart';

@HiveType(typeId: 0)
class Resume extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String education;

  @HiveField(5)
  final String skills;

  @HiveField(6)
  final String? experience;

  @HiveField(7)
  final DateTime updatedAt;

  Resume({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.education,
    required this.skills,
    this.experience,
    required this.updatedAt,
  });

  Resume copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? education,
    String? skills,
    String? experience,
    DateTime? updatedAt,
  }) {
    return Resume(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
