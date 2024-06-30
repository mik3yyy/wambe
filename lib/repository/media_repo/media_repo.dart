import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';

abstract class MediaRepo {
  Future<Map<String, dynamic>> UploadFile(
      {required List<Map<String, String>> files, required String tag});
  Future<MediaResponse> fetchMedia(String eventId, int page, int pageSize);
  Future<void> fetchMyMedia(String eventId, int page, int pageSize);
  Future<MediaData> fetchRoundupMedia();
  Future<Map<String, dynamic>> getEventMediaTags();
  Future<Map<String, dynamic>> fetchUserRoundupMedia();
  Future<Map<String, dynamic>> getTagMedia(String tag, int page, int pageSize);

  Future<Map<String, dynamic>> deleteMedia({
    required List<int> ids,
  });
}
