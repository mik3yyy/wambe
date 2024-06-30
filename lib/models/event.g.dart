// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      uploadLimit: fields[0] as String,
      totalMedia: fields[1] as int,
      totalAttendees: fields[2] as String,
      eventEnd: fields[3] as bool,
      eventId: fields[4] as String,
      eventName: fields[6] as String,
      eventPublic: fields[5] as bool,
      paid: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uploadLimit)
      ..writeByte(1)
      ..write(obj.totalMedia)
      ..writeByte(2)
      ..write(obj.totalAttendees)
      ..writeByte(3)
      ..write(obj.eventEnd)
      ..writeByte(4)
      ..write(obj.eventId)
      ..writeByte(5)
      ..write(obj.eventPublic)
      ..writeByte(6)
      ..write(obj.eventName)
      ..writeByte(7)
      ..write(obj.paid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
