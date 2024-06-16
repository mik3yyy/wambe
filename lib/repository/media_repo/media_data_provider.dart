import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:wambe/settings/constants.dart';
import 'package:dio/dio.dart';
import 'package:wambe/settings/hive.dart';

class MediaDataProvider {
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

  static Future<http.Response> deleteMedia(
    List<int> ids,
  ) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '${Constants.url}/delete-media',
        ),
        headers: {
          "accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": Constants.token
        },
        body: json.encode({
          "mediaIds": ids,
          "uuid": HiveFunction.getUser().userId,
          "eventId": HiveFunction.getEvent().eventId
        }),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Response> uploadFiles({
    required List<String> files,
    // required String uuid,
    // required String eventId,
  }) async {
    var dio = Dio();

    // Create a list of MultipartFile objects for images
    List<MultipartFile> imageFiles = [];
    for (String path in files) {
      imageFiles.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last));
    }

    var formData = FormData.fromMap(
      {
        'eventId': HiveFunction.getEvent().eventId,
        'uuid': HiveFunction.getUser().userId,
        'media': imageFiles
      },
    );

    try {
      Response response = await dio.post(
        '${Constants.url}/upload-media',
        options: Options(
          headers: {
            "Authorization": Constants.token,
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
