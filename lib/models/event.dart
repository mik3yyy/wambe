import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  String uploadLimit;

  @HiveField(1)
  int totalMedia;

  @HiveField(2)
  String totalAttendees;

  @HiveField(3)
  bool eventEnd;

  @HiveField(4)
  String eventId;

  @HiveField(5)
  bool eventPublic;

  @HiveField(6)
  String eventName;

  Event({
    required this.uploadLimit,
    required this.totalMedia,
    required this.totalAttendees,
    required this.eventEnd,
    required this.eventId,
    required this.eventName,
    required this.eventPublic,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        uploadLimit: json['eventPlan']['uploadLimit'].toString(),
        totalMedia: json['eventPlan']['totalMedia'],
        totalAttendees: json['eventPlan']['totalAttendees'].toString(),
        eventEnd: json['eventEnd'],
        eventName: json['eventName'],
        eventPublic: json['eventPublic'],
        eventId: json['eventId'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'eventPlan': {
          'uploadLimit': uploadLimit,
          'totalMedia': totalMedia,
          'totalAttendees': totalAttendees,
        },
        'eventEnd': eventEnd,
        'eventName': eventName,
        'eventPublic': eventPublic,
        'eventId': eventId,
      };
}
