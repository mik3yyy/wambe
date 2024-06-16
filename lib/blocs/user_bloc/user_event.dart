part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class SigninEvent extends UserEvent {
  final String event;

  SigninEvent({
    required this.event,
  });
}

final class ClearUserEvent extends UserEvent {}

final class WelcomeUserEvent extends UserEvent {
  // final User user;
  final String eventId;
  final String name;
  final String email;
  WelcomeUserEvent(
      {required this.eventId, required this.name, required this.email});
}

final class RestoreEvent extends UserEvent {
  // final User user;
  final Event event;
  final User user;

  RestoreEvent({required this.event, required this.user});
}

final class ChangeNameEvent extends UserEvent {
  // final User user;
  final String name;

  ChangeNameEvent({
    required this.name,
  });
}
