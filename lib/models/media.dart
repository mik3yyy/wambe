// models/media_model.dart

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'media.g.dart';

@HiveType(typeId: 5)
class Media extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String createdAt;

  @HiveField(3)
  final String uuid;

  @HiveField(4)
  final String eventId;

  @HiveField(5)
  final String tag;

  Media(
      {required this.url,
      required this.createdAt,
      required this.uuid,
      required this.eventId,
      required this.tag,
      required this.id});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'],
      createdAt: json['created_at'],
      uuid: json['uuid'],
      tag: json['tag'],
      eventId: json['eventId'],
      id: json['id'],
    );
  }

  @override
  List<Object?> get props => [url, createdAt];
}

@HiveType(typeId: 4)
class MediaResponse extends HiveObject {
  @HiveField(0)
  final Map<String, List<Media>> media;

  MediaResponse({required this.media});

  factory MediaResponse.fromJson(Map<String, dynamic> json) {
    final media = <String, List<Media>>{};
    json.forEach((key, value) {
      media[key] = List<Media>.from(value.map((item) => Media.fromJson(item)));
    });
    return MediaResponse(media: media);
  }
}
