import 'package:hive/hive.dart';

part 'media_data.g.dart';

@HiveType(typeId: 2)
class MediaData extends HiveObject {
  @HiveField(0)
  int totalMediaCount;

  @HiveField(1)
  Map<String, int> imageCountsPerHour;

  @HiveField(2)
  int totalUserCount;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  int durationInHours;

  @HiveField(6)
  List<TopContributor> topContributors;

  MediaData({
    required this.totalMediaCount,
    required this.imageCountsPerHour,
    required this.totalUserCount,
    required this.startDate,
    required this.endDate,
    required this.durationInHours,
    required this.topContributors,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) => MediaData(
        totalMediaCount: json['totalMediaCount'],
        imageCountsPerHour: Map<String, int>.from(json['imageCountsPerHour']),
        totalUserCount: json['totalUserCount'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        durationInHours: json['durationInHours'],
        topContributors: (json['topContributors'] as List<dynamic>)
            .map((e) => TopContributor.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'totalMediaCount': totalMediaCount,
        'imageCountsPerHour': imageCountsPerHour,
        'totalUserCount': totalUserCount,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'durationInHours': durationInHours,
        'topContributors': topContributors.map((e) => e.toJson()).toList(),
      };
}

@HiveType(typeId: 3)
class TopContributor extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String uuid;

  @HiveField(2)
  String name;

  @HiveField(3)
  int mediaCount;

  TopContributor({
    required this.id,
    required this.uuid,
    required this.name,
    required this.mediaCount,
  });

  factory TopContributor.fromJson(Map<String, dynamic> json) => TopContributor(
        id: json['id'],
        uuid: json['uuid'],
        name: json['name'],
        mediaCount: json['mediaCount'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'mediaCount': mediaCount,
      };
}
