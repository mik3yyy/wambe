import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/models/media_data.dart';
import 'package:wambe/repository/media_repo/media_implementation.dart';
import 'package:wambe/settings/hive.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final mediaRepoImp mediaRepo;
  int page = 1;
  final int pageSize = 20;
  MediaBloc({required this.mediaRepo}) : super(MediaInitial()) {
    on<AddImageEvent>(_addfile);
    on<UploadFilesEvent>(_uploadFile);
    on<LoadMediaEvent>(_getMedia);
    on<ClearMediaEvent>(_clear);
    on<RemoveImageEvent>(_removeImage);
    on<DeleteMediaEvent>(_deleteMedia);
    on<GetEventRoundup>(_getEventMedia);
    on<GetuserRoundup>(_getUserMedia);
    on<RestoreMyMomentEvent>(_restoreMyMonet);
  }
  _restoreMyMonet(RestoreMyMomentEvent event, Emitter emit) async {
    MediaResponse response = HiveFunction.getMyMoment();
    emit(
      MediaLoaded(
          selectedImages: state.selectedImages,
          media: response.media,
          message: "Loaded Successfully"),
    );
  }

  _getUserMedia(GetuserRoundup event, Emitter emit) async {
    // fetchRoundupMedia
    emit(MediaProcessing(
        isEventRoundup: true,
        selectedImages: state.selectedImages,
        media: state.media));
    try {
      var response = await mediaRepo.fetchUserRoundupMedia();
      HiveFunction.insertuserRoundup(response);
      emit(MediaLoaded(
        message: "Successs",
        selectedImages: state.selectedImages,
        media: state.media,
      ));
    } catch (e) {
      print(e.toString());
      emit(
        MediaError(
          message: "Error Loading",
          selectedImages: state.selectedImages,
          media: state.media,
        ),
      );
      // Me(message: "Check your network", user: state.user);
    }
  }

  _getEventMedia(GetEventRoundup event, Emitter emit) async {
    // fetchRoundupMedia
    emit(MediaProcessing(
        isEventRoundup: true,
        selectedImages: state.selectedImages,
        media: state.media));
    try {
      MediaData response = await mediaRepo.fetchRoundupMedia();
      HiveFunction.insertEventRoundup(response);
      emit(MediaLoaded(
        message: "Successs",
        selectedImages: state.selectedImages,
        media: state.media,
      ));
    } catch (e) {
      print(e.toString());
      emit(
        MediaError(
          message: "Error Loading",
          selectedImages: state.selectedImages,
          media: state.media,
        ),
      );
      // Me(message: "Check your network", user: state.user);
    }
  }

  _deleteMedia(DeleteMediaEvent event, Emitter emit) async {
    emit(MediaProcessing(
        isDeleting: true,
        selectedImages: state.selectedImages,
        media: state.media));
    try {
      Map<String, dynamic> response =
          await mediaRepo.deleteMedia(ids: event.ids);
      print(response);
      if (response['success']) {
        emit(
          MediaLoaded(
              selectedImages: state.selectedImages,
              message: "Deleted Image(s) Succesfully",
              media: state.media),
        );
        add(LoadMediaEvent(eventId: HiveFunction.getEvent().eventId));
      } else {
        if (response['status'] != null) {
          emit(
            MediaError(
                message: "Error Deleting Image(s)",
                media: state.media,
                selectedImages: state.selectedImages),
          );
        } else {
          emit(
            MediaError(
              message: "Error Deleting Image(s), Check Network",
              media: state.media,
              selectedImages: state.selectedImages,
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      // Me(message: "Check your network", user: state.user);
    }
  }

  _uploadFile(UploadFilesEvent event, Emitter emit) async {
    emit(MediaProcessing(
        isUploading: true,
        selectedImages: state.selectedImages,
        media: state.media));
    try {
      Map<String, dynamic> response = await mediaRepo.UploadFile(
        files: state.selectedImages!,
      );
      print(response);
      if (response['success']) {
        emit(
          MediaLoaded(
              selectedImages: [],
              message: "Uploaded Images Succesfully",
              media: state.media),
        );
        add(LoadMediaEvent(eventId: HiveFunction.getEvent().eventId));
      } else {
        if (response['status'] != null) {
          emit(
            MediaError(
                message: "Error Uploading Image",
                media: state.media,
                selectedImages: state.selectedImages),
          );
        } else {
          emit(
            MediaError(
              message: "Error Uploading Image, Check Network",
              media: state.media,
              selectedImages: state.selectedImages,
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      // Me(message: "Check your network", user: state.user);
    }
  }

  _removeImage(RemoveImageEvent event, Emitter emit) async {
    var image = state.selectedImages ?? [];
    print(image.length);
    image.removeAt(event.index);
    print(image.length);

    emit(
      MediaLoaded(
        selectedImages: image,
        message: "Removed Successffully",
        media: state.media,
      ),
    );
  }

  _clear(ClearMediaEvent event, Emitter emit) async {
    emit(MediaLoaded(message: "Done", media: state.media, selectedImages: []));
  }

  Map<String, List<Media>> resolveMediaConflicts(
      Map<String, List<Media>>? stateMedia,
      Map<String, List<Media>> mediaResponseMedia) {
    final allMedia = <String, List<Media>>{};
    if (stateMedia == null) return mediaResponseMedia;
    // Add all entries from stateMedia to allMedia
    stateMedia.forEach((key, value) {
      allMedia[key] = List.from(value); // Ensure a new list is created
    });

    // Add entries from mediaResponseMedia to allMedia, resolving conflicts
    mediaResponseMedia.forEach((key, value) {
      if (allMedia.containsKey(key)) {
        allMedia[key]!.addAll(value); // Add new values to existing list
      } else {
        allMedia[key] = List.from(value); // Add new key with its values
      }
    });

    return allMedia;
  }

  _getMedia(LoadMediaEvent event, Emitter emit) async {
    emit(
      MediaProcessing(
          selectedImages: state.selectedImages,
          isFetching: true,
          media: state.media),
    );

    emit(MediaProcessing(
        selectedImages: state.selectedImages, media: state.media));
    if (event.add) {
      page++;
    } else {
      page = 1;
    }
    try {
      await mediaRepo.fetchMyMedia(event.eventId, 1, 5);
      final mediaResponse =
          await mediaRepo.fetchMedia(event.eventId, page, pageSize);
      print(mediaResponse);
      if (mediaResponse.media.isEmpty && event.add) {
        page--;
      }
      // page++;

      final allMedia = resolveMediaConflicts(
        event.add ? state.media : {},
        mediaResponse.media,
      );
      var response = MediaResponse(media: allMedia);
      HiveFunction.insertMyMoment(response);

      emit(MediaLoaded(
          selectedImages: state.selectedImages,
          media: allMedia,
          message: "Loaded Successfully"));
    } catch (e) {
      if (event.add) {
        page--;
      } else {
        page = 1;
      }
      // page--;
      emit(
        MediaError(
            selectedImages: state.selectedImages,
            media: state.media,
            message: "Error, Please check your  network"),
      );
    }
  }

  _addfile(AddImageEvent event, Emitter emit) {
    var image = state.selectedImages ?? [];
    for (var i in event.images) {
      image.add(i);
    }
    emit(
      MediaLoaded(
          selectedImages: image,
          message: "Uploaded Successffully",
          media: state.media),
    );
  }
}
