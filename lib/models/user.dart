import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  String eventId;

  @HiveField(2)
  bool eventOwner;

  @HiveField(3) // Add the HiveField annotation for userId
  String userId;

  User({
    required this.name,
    required this.eventId,
    required this.eventOwner,
    required this.userId, // Include userId in the constructor
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      eventId: json['eventId'],
      eventOwner: json['eventOwner'],
      userId: json['userid'], // Parse userId from JSON
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'eventId': eventId,
      'eventOwner': eventOwner,
      'userId': userId, // Include userId in the JSON map
    };
  }
}
