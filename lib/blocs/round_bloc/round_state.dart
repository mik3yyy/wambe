part of 'round_bloc.dart';

sealed class RoundState extends Equatable {
  const RoundState();

  @override
  List<Object> get props => [];
}

final class RoundInitial extends RoundState {}

final class RoundProcessing extends RoundState {
  final bool isEvent;
  final bool isUser;

  RoundProcessing({this.isEvent = false, this.isUser = false});
}

final class RoundError extends RoundState {}

final class RoundLoaded extends RoundState {}
