import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'round_event.dart';
part 'round_state.dart';

class RoundBloc extends Bloc<RoundEvent, RoundState> {
  RoundBloc() : super(RoundInitial()) {
    on<GetEventRoundup>(_getEventRoundup);
  }
  _getEventRoundup(GetEventRoundup event, Emitter emit) async {
    emit(RoundProcessing(isEvent: false));
  }
}
