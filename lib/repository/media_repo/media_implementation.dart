import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';
import 'package:wambe/repository/media_repo/media_data_provider.dart';
import 'package:wambe/repository/media_repo/media_repo.dart';
import 'package:wambe/repository/user_repo/user_data_provider.dart';
import 'package:wambe/settings/constants.dart';
import 'package:wambe/settings/hive.dart';

class mediaRepoImp implements MediaRepo {
  @override
  Future<Map<String, dynamic>> UploadFile({
    required List<String> files,
  }) async {
    try {
      final res = await MediaDataProvider.uploadFiles(files: files);
      final data = res.data as Map;

      if ((res.statusCode ?? 500) >= 200 && (res.statusCode ?? 500) < 300) {
        return {'success': true, 'status': res.statusCode, 'data': data};
      } else {
        return {'success': false, 'status': res.statusCode, 'data': data};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<MediaResponse> fetchMedia(
      String eventId, int page, int pageSize) async {
    print("------");
    final response = await Dio().get(
      '${Constants.url}/my-media', //event-media',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      // queryParameters: {
      //   'eventId': eventId,
      //   'page': page,
      //   'pageSize': pageSize,
      // },
      queryParameters: {
        'uuid': HiveFunction.getUser().userId,
        'page': page,
        'pageSize': pageSize,
      },
    );
    print(response.data as Map);

    if (response.statusCode == 200) {
      return MediaResponse.fromJson(response.data['media']);
    } else {
      throw Exception('Failed to load media');
    }
  }

  @override
  Future<void> fetchMyMedia(String eventId, int page, int pageSize) async {
    print("------");
    final response = await Dio().get(
      '${Constants.url}/my-media',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {
        'uuid': HiveFunction.getUser().userId,
        'page': page,
        'pageSize': pageSize,
      },
    );
    HiveFunction.insertTotalMedia(totalMedia: response.data['totalMedia']);
    // if (response.statusCode == 200) {
    //   return MediaResponse.fromJson(response.data['media']);
    // } else {
    //   throw Exception('Failed to load media');
    // }
  }

  @override
  Future<Map<String, dynamic>> deleteMedia({required List<int> ids}) async {
    try {
      final res = await MediaDataProvider.deleteMedia(ids);
      final data = json.decode(res.body);

      if ((res.statusCode) >= 200 && (res.statusCode) < 300) {
        return {'success': true, 'status': res.statusCode, 'data': data};
      } else {
        return {'success': false, 'status': res.statusCode, 'data': data};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<MediaData> fetchRoundupMedia() async {
    print("------");
    final response = await Dio().get(
      '${Constants.url}/event-stat?eventId=${HiveFunction.getEvent().eventId}',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {},
    );
    print(response.data as Map);

    if (response.statusCode == 200) {
      return MediaData.fromJson(response.data);
    } else {
      throw Exception('Failed to load media');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchUserRoundupMedia() async {
    print("------");
    final response = await Dio().get(
      '${Constants.url}/user-event-stat?eventId=${HiveFunction.getEvent().eventId}&userId=${HiveFunction.getUser().userId}',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {},
    );
    print(response.data as Map);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load media');
    }
  }
}
