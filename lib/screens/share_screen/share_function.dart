import 'package:dio/dio.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/settings/constants.dart';
import 'package:wambe/settings/hive.dart';

class ShareFunction {
  static Future<Map<String, List<Media>>> getData(
      {required String id,
      required int pageNumber,
      required int pageSized}) async {
    final response = await Dio().get(
      '${Constants.url}/event-media',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {
        'eventId': id,
        // 'page': pageNumber,
        // 'pageSize': pageSized,
      },
    );
    MediaResponse mediaResponse =
        MediaResponse.fromJson(response.data['media']);
    return mediaResponse.media;
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
