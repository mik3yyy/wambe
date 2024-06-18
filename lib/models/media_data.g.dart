// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaDataAdapter extends TypeAdapter<MediaData> {
  @override
  final int typeId = 2;

  @override
  MediaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaData(
      totalMediaCount: fields[0] as int,
      imageCountsPerHour: (fields[1] as Map).cast<String, int>(),
      totalUserCount: fields[2] as int,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      durationInHours: fields[5] as int,
      topContributors: (fields[6] as List).cast<TopContributor>(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.totalMediaCount)
      ..writeByte(1)
      ..write(obj.imageCountsPerHour)
      ..writeByte(2)
      ..write(obj.totalUserCount)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.durationInHours)
      ..writeByte(6)
      ..write(obj.topContributors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopContributorAdapter extends TypeAdapter<TopContributor> {
  @override
  final int typeId = 3;

  @override
  TopContributor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopContributor(
      id: fields[0] as int,
      uuid: fields[1] as String,
      name: fields[2] as String,
      mediaCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TopContributor obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.mediaCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopContributorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
