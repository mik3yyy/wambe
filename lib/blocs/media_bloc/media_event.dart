part of 'media_bloc.dart';

@immutable
sealed class MediaEvent {}

final class AddImageEvent extends MediaEvent {
  final List<String> images;

  AddImageEvent({
    required this.images,
  });
}

final class RemoveImageEvent extends MediaEvent {
  final int index;

  RemoveImageEvent({required this.index});
}

final class UploadFilesEvent extends MediaEvent {}

final class RestoreMyMomentEvent extends MediaEvent {}

final class ClearMediaEvent extends MediaEvent {}

final class GetEventRoundup extends MediaEvent {}

final class GetuserRoundup extends MediaEvent {}

final class DeleteMediaEvent extends MediaEvent {
  final List<int> ids;

  DeleteMediaEvent({required this.ids});
}

class LoadMediaEvent extends MediaEvent {
  final String eventId;
  final bool add;

  LoadMediaEvent({required this.eventId, this.add = false});
}
