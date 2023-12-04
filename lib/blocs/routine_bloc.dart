import 'dart:async';

import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final RoutineRepository _routineRepository;

  RoutineBloc(this._routineRepository) : super(InitialRoutineState()) {
    on<LoadAllRoutineEvent>(_loadAllRoutines);
    on<AddRoutineEvent>(_addRoutine);
  }

  FutureOr<void> _loadAllRoutines(LoadAllRoutineEvent event, Emitter<RoutineState> emit) async {
    var allRoutines = await _routineRepository.getAllRoutines();
    emit(LoadedAllRoutineState(allRoutines));
  }

  FutureOr<void> _addRoutine(AddRoutineEvent event, Emitter<RoutineState> emit) async {
    await _routineRepository.addRoutine(event.routine);
    var allRoutines = await _routineRepository.getAllRoutines();
    emit(LoadedAllRoutineState(allRoutines));
  }
}