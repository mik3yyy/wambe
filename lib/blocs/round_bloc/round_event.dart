part of 'round_bloc.dart';

sealed class RoundEvent extends Equatable {
  const RoundEvent();

  @override
  List<Object> get props => [];
}

final class GetEventRoundup extends RoundEvent {}
