// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeAdapter extends TypeAdapter<Resume> {
  @override
  final int typeId = 0;

  @override
  Resume read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resume(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String,
      education: fields[4] as String,
      skills: fields[5] as String,
      experience: fields[6] as String?,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Resume obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.education)
      ..writeByte(5)
      ..write(obj.skills)
      ..writeByte(6)
      ..write(obj.experience)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
