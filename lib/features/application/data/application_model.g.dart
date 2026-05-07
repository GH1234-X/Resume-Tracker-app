// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobApplicationAdapter extends TypeAdapter<JobApplication> {
  @override
  final int typeId = 1;

  @override
  JobApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplication(
      id: fields[0] as String,
      companyName: fields[1] as String,
      jobRole: fields[2] as String,
      dateApplied: fields[3] as DateTime,
      resumeId: fields[4] as String?,
      status: fields[5] as String,
      userId: fields[6] as String?,
      isSynced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplication obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.jobRole)
      ..writeByte(3)
      ..write(obj.dateApplied)
      ..writeByte(4)
      ..write(obj.resumeId)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
