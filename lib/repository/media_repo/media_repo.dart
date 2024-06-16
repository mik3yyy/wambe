import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';

abstract class MediaRepo {
  Future<Map<String, dynamic>> UploadFile({
    required List<String> files,
  });
  Future<MediaResponse> fetchMedia(String eventId, int page, int pageSize);
  Future<void> fetchMyMedia(String eventId, int page, int pageSize);
  Future<MediaData> fetchRoundupMedia();
  Future<Map<String, dynamic>> fetchUserRoundupMedia();

  Future<Map<String, dynamic>> deleteMedia({
    required List<int> ids,
  });
}
