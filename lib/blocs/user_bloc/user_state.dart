part of 'user_bloc.dart';

@immutable
sealed class UserState {
  final User? user;
  final Event? event;
  UserState({this.user, this.event});
}

final class UserInitial extends UserState {
  final User? user;
  final Event? event;
  UserInitial({this.event, this.user});
}

class UserProcessing extends UserState {
  final bool isSignInEvent;
  final bool isInputingName;
  final bool isChangeName;

  final User? user;
  final Event? event;

  UserProcessing({
    this.isInputingName = false,
    this.isSignInEvent = false,
    this.isChangeName = false,
    this.user,
    this.event,
  });
}

class UserError extends UserState {
  final String message;
  final User? user;
  final Event? event;

  UserError({required this.message, this.user, this.event});
}

class userLoaded extends UserState {
  final User? user;
  final String message;
  final Event? event;

  userLoaded({this.user, required this.message, this.event});
}
