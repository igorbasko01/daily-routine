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
    on<UpdateRoutineEvent>(_updateRoutine);
    on<DeleteRoutineEvent>(_deleteRoutine);
  }

  FutureOr<void> _loadAllRoutines(LoadAllRoutineEvent event, Emitter<RoutineState> emit) async {
    var allRoutines = await _routineRepository.getAllRoutines();
    emit(LoadedAllRoutineState(allRoutines));
  }

  FutureOr<void> _addRoutine(AddRoutineEvent event, Emitter<RoutineState> emit) async {
    var allRoutines = await _routineRepository.addRoutine(event.routine);
    emit(LoadedAllRoutineState(allRoutines));
  }

  FutureOr<void> _updateRoutine(UpdateRoutineEvent event, Emitter<RoutineState> emit) async {
    try {
      var allRoutines = await _routineRepository.updateRoutine(event.routine);
      emit(LoadedAllRoutineState(allRoutines));
    } on RoutineNotFoundException catch (e) {
      emit(ErrorRoutineState(e));
    }
  }

  FutureOr<void> _deleteRoutine(DeleteRoutineEvent event, Emitter<RoutineState> emit) async {
    try {
      var allRoutines = await _routineRepository.deleteRoutine(event.id);
      emit(LoadedAllRoutineState(allRoutines));
    } on RoutineNotFoundException catch (e) {
      emit(ErrorRoutineState(e));
    }
  }
}