import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:wambe/settings/constants.dart';
import 'package:wambe/settings/hive.dart';

class UserDataProvider {
  static Future<http.Response> signIn(
    String event,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/onboard-event',
        ),
        headers: {
          "accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": Constants.token
        },
        body: json.encode(
          {
            'eventId': event,
          },
        ),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<http.Response> welcomeUser({
    required String eventID,
    required String name,
    required String email,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/onboard-user',
        ),
        headers: {
          "accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": Constants.token
        },
        body: json.encode({
          "name": name,
          "email": email,
          "eventId": eventID,
          "eventOwner": false
        }),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Response> chnageName({
    required String name,
  }) async {
    try {
      // print(
      //   '${Constants.url}/update-user/?uuid=${HiveFunction.getUser().userId}',
      // );
      // final res = await http.put(
      //   Uri.parse(
      //     '${Constants.url}/update-user/:uuid=${HiveFunction.getUser().userId}',
      //   ),
      //   headers: {
      //     "accept": "application/json",
      //     'Content-Type': 'application/json',
      //     "Authorization": Constants.token
      //   },
      //   body: json.encode({
      //     "name": name,
      //   }),
      // );
      final response = await Dio().put(
        '${Constants.url}/update-user/${HiveFunction.getUser().userId}',
        options: Options(
          headers: {
            "accept": "application/json",
            'Content-Type': 'application/json',
            "Authorization": Constants.token
          },
        ),
        queryParameters: {
          'uuid': HiveFunction.getUser().userId,
        },
        data: json.encode({"name": name}),
        onSendProgress: (count, total) {
          print(total);
          print(count);
        },
      ); //json.encode({"name": name}));

      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
