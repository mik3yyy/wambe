part of 'media_bloc.dart';

@immutable
abstract class MediaState extends Equatable {
  final List<Map<String, String>>? selectedImages;
  final Map<String, List<Media>>? media;

  const MediaState({this.selectedImages, this.media});

  @override
  List<Object?> get props => [selectedImages, media];
}

class MediaInitial extends MediaState {
  const MediaInitial(
      {List<Map<String, String>>? selectedImages,
      Map<String, List<Media>>? media})
      : super(selectedImages: selectedImages, media: media);
}

class MediaLoaded extends MediaState {
  final String message;

  const MediaLoaded(
      {List<Map<String, String>>? selectedImages,
      Map<String, List<Media>>? media,
      required this.message})
      : super(selectedImages: selectedImages, media: media);

  @override
  List<Object?> get props => [selectedImages, media, message];
}

class MediaProcessing extends MediaState {
  final bool isFetching;
  final bool isMoreFetching;
  final bool isPicking;
  final bool isUploading;
  final bool isDeleting;
  final bool isEventRoundup;
  const MediaProcessing(
      {List<Map<String, String>>? selectedImages,
      Map<String, List<Media>>? media,
      this.isFetching = false,
      this.isDeleting = false,
      this.isPicking = false,
      this.isEventRoundup = false,
      this.isMoreFetching = false,
      this.isUploading = false})
      : super(selectedImages: selectedImages, media: media);
}

class MediaError extends MediaState {
  final String message;

  const MediaError(
      {List<Map<String, String>>? selectedImages,
      Map<String, List<Media>>? media,
      required this.message})
      : super(selectedImages: selectedImages, media: media);

  @override
  List<Object?> get props => [selectedImages, media, message];
}
