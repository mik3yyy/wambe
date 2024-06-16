// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 5;

  @override
  Media read(BinaryReader reader) {
    return Media(
      url: reader.readString(),
      createdAt: reader.readString(),
      uuid: reader.readString(),
      id: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer.writeString(obj.url);
    writer.writeString(obj.createdAt);
    writer.writeString(obj.uuid);
    writer.writeInt(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaResponseAdapter extends TypeAdapter<MediaResponse> {
  @override
  final int typeId = 4;

  @override
  MediaResponse read(BinaryReader reader) {
    final media = <String, List<Media>>{};
    final numEntries = reader.readInt();
    for (int i = 0; i < numEntries; i++) {
      final key = reader.readString();
      final value = reader.readList().cast<Media>();
      media[key] = value;
    }
    return MediaResponse(media: media);
  }

  @override
  void write(BinaryWriter writer, MediaResponse obj) {
    writer.writeInt(obj.media.length);
    obj.media.forEach((key, value) {
      writer.writeString(key);
      writer.writeList(value);
    });
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
