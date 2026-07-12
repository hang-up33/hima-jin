// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlocked_achievement_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnlockedAchievementHiveAdapter
    extends TypeAdapter<UnlockedAchievementHive> {
  @override
  final int typeId = 1;

  @override
  UnlockedAchievementHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnlockedAchievementHive(
      achievementId: fields[0] as String,
      unlockedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UnlockedAchievementHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.achievementId)
      ..writeByte(1)
      ..write(obj.unlockedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnlockedAchievementHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
