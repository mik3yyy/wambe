import 'package:hive_flutter/adapters.dart';
import 'package:wambe/models/event.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';
import 'package:wambe/models/user.dart';

class HiveFunction {
  static var wambeBox = Hive.box('wambe');
  static void insertUser(User user) {
    wambeBox.put("user", user);
  }

  static void insertEvent(Event evemt) {
    wambeBox.put("event", evemt);
  }

  static void insertEventAndUSER({required Event evemt, required User user}) {
    wambeBox.put("event", evemt);
    wambeBox.put("user", user);
  }

  static User getUser() {
    return wambeBox.get("user");
  }

  static Event getEvent() {
    return wambeBox.get("event");
  }

  static void deleteuser() {
    wambeBox.delete("user");
  }

  static void deleteEvent() {
    wambeBox.delete("event");
  }

  static bool userExist() {
    return wambeBox.get("user") != null;
  }

  static bool ueventExist() {
    return wambeBox.get("event") != null;
  }

  static void insertEventUsers(List<User> users) {
    wambeBox.put("users", users);
  }

  static void insertEventRoundup(MediaData data) {
    wambeBox.put("round_up", data);
    wambeBox.put("current_round_event", HiveFunction.getEvent().eventId);
  }

  static MediaData getEventRoundu() {
    return wambeBox.get(
      "round_up",
    );
  }

  static void deleteRoundup() {
    wambeBox.delete("round_up");
  }

  static bool roundupExist() {
    return wambeBox.get("round_up") != null;
  }

  static void insertuserRoundup(Map<String, dynamic> data) {
    wambeBox.put("user_round_up", data);
    wambeBox.put("current_round_event", HiveFunction.getEvent().eventId);
  }

  static Map<dynamic, dynamic>? getUserRoundu() {
    return wambeBox.get("user_round_up");
  }

  static void deleteUserRoundup() {
    wambeBox.delete("user_round_up");
  }

  static bool roundupuserExist() {
    return wambeBox.get("user_round_up") != null;
  }

  static List<User> getEventusers() {
    final List<dynamic> dynamicList = wambeBox.get('users', defaultValue: []);
    final List<User> eventusers = dynamicList.cast<User>();

    return eventusers;
  }

  static void insertTotalMedia({required int totalMedia}) {
    wambeBox.put("totalMedia", totalMedia);
  }

  static int getTotalUpload() {
    return wambeBox.get("totalMedia", defaultValue: 0);
  }

/////////////////
  static void deleteMyMoment() {
    wambeBox.delete("my_moment");
  }

  static bool myMomentExist() {
    return wambeBox.get("my_moment") != null;
  }

  static MediaResponse getMyMoment() {
    return wambeBox.get("my_moment");
  }

  static void insertMyMoment(MediaResponse response) {
    wambeBox.put("my_moment", response);
  }

  /////////////////////
  static void DELETEALL() {
    deleteuser();
    deleteEvent();
    deleteMyMoment();
  }
}
