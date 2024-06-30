import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:wambe/models/event.dart';
import 'package:wambe/models/user.dart';
import 'package:wambe/repository/user_repo/user_implementation.dart';
import 'package:wambe/settings/hive.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userRepoImp userRepo;

  UserBloc({required this.userRepo}) : super(UserInitial()) {
    on<SigninEvent>(_signInEvent);
    on<WelcomeUserEvent>(_welcomeUser);
    on<RestoreEvent>(_restoreEvent);
    on<ChangeNameEvent>(_chnageName);
    on<ClearUserEvent>(_clear);
  }
  _clear(ClearUserEvent event, Emitter emit) async {
    emit(userLoaded(message: "Done"));
  }

  _chnageName(ChangeNameEvent event, Emitter emit) async {
    emit(UserProcessing(
        isChangeName: true, user: state.user, event: state.event));
    try {
      Map<String, dynamic> response = await userRepo.chnageName(
        name: event.name,
      );
      User currentData = HiveFunction.getUser();
      User newData = User(
        name: event.name,
        eventId: currentData.eventId,
        eventOwner: currentData.eventOwner,
        userId: currentData.userId,
      );
      print(response);
      if (response['success']) {
        HiveFunction.insertUser(newData);
        emit(
          userLoaded(
            event: state.event,
            message: "Event Login Succesful",
            user: newData,
          ),
        );
      } else {
        if (response['status'] != null) {
          emit(UserError(
            message: response['data']['error'],
            user: state.user,
            event: state.event,
          ));
        } else {
          emit(UserError(
            message: "Check your network",
            user: state.user,
            event: state.event,
          ));
        }
      }
    } catch (e) {
      emit(UserError(message: "Check your network", user: state.user));
    }
  }

  _restoreEvent(RestoreEvent event, Emitter emit) async {
    emit(UserProcessing(
        isSignInEvent: true, user: state.user, event: state.event));
    emit(userLoaded(message: "Loaded", user: event.user, event: event.event));
    print(event.user.toJson());
    print(event.event.toJson());
  }

  _signInEvent(SigninEvent event, Emitter emit) async {
    emit(UserProcessing(
        isSignInEvent: true, user: state.user, event: state.event));
    try {
      Map<String, dynamic> response = await userRepo.signIn(
        event: event.event,
      );
      if (response['success']) {
        List<User> users = [];

        for (var res in response['data']['eventUsers']) {
          users.add(User.fromJson(res));
        }
        HiveFunction.insertEventUsers(users);

        HiveFunction.insertTags(response['data']['tags']);

        if (response['data']['paid'] == false) {
          emit(UserError(
            message: "Event has not being paid for",
            user: state.user,
            event: state.event,
          ));
          return;
        }
        var eve = Event.fromJson(
          response['data'],
        );
        emit(
          userLoaded(
            event: eve,
            message: "Event Login Succesful",
            user: state.user,
          ),
        );
      } else {
        if (response['status'] != null) {
          emit(UserError(
            message: response['data']['error'],
            user: state.user,
            event: state.event,
          ));
        } else {
          emit(UserError(
            message: "Check your network",
            user: state.user,
            event: state.event,
          ));
        }
      }
    } catch (e) {
      emit(UserError(message: "Check your network", user: state.user));
    }
  }

  _welcomeUser(WelcomeUserEvent event, Emitter emit) async {
    emit(UserProcessing(
        isInputingName: true, user: state.user, event: state.event));
    try {
      Map<String, dynamic> response = await userRepo.welcomeUser(
        eventID: event.eventId,
        name: event.name,
        email: event.email,
      );

      if (response['success']) {
        print(response);
        User user = User.fromJson(
          response['data'],
        );
        print(user);
        HiveFunction.insertEventAndUSER(evemt: state.event!, user: user);

        emit(
          userLoaded(
            event: state.event,
            message: "Event Login Succesful",
            user: user,
          ),
        );
      } else {
        if (response['status'] != null) {
          if (response['status'] == 400) {
            User user = User.fromJson(
              response['data']['existingUser'],
            );
            HiveFunction.insertEventAndUSER(evemt: state.event!, user: user);

            emit(
              userLoaded(
                event: state.event,
                message: "Event Login Succesful",
                user: user,
              ),
            );
          } else {
            emit(UserError(
              message: response['data']['error'],
              user: state.user,
              event: state.event,
            ));
          }
        } else {
          emit(UserError(
            message: "Check your network",
            user: state.user,
            event: state.event,
          ));
        }
      }
    } catch (e) {
      emit(UserError(message: "Check your network", user: state.user));
    }
  }
}
