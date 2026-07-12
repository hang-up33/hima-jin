// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityLogHiveAdapter extends TypeAdapter<ActivityLogHive> {
  @override
  final int typeId = 0;

  @override
  ActivityLogHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityLogHive(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      tagIndex: fields[2] as int,
      note: fields[3] as String,
      durationMinutes: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityLogHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.tagIndex)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityLogHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
