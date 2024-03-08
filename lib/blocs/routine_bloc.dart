import 'dart:async';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final RoutineRepository _routineRepository;

  RoutineBloc(this._routineRepository) : super(InitialRoutineState()) {
    on<LoadAllRoutineEvent>(_loadAllRoutines);
    on<AddRoutineEvent>(_addRoutine);
    on<UpdateRoutineEvent>(_updateRoutine);
    on<DeleteRoutineEvent>(_deleteRoutine);
    on<ResetAllRoutineEvent>(_resetAllRoutines);
    on<HandleDayChangeRoutineEvent>(_handleDayChange);
    on<MarkCompleteRoutineEvent>(_markCompleteRoutine);
    on<MarkIncompleteRoutineEvent>(_markIncompleteRoutine);
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

  FutureOr<void> _resetAllRoutines(ResetAllRoutineEvent event, Emitter<RoutineState> emit) async {
    var routines = await _routineRepository.resetAllRoutines();
    emit(LoadedAllRoutineState(routines));
  }

  FutureOr<void> _handleDayChange(HandleDayChangeRoutineEvent event, Emitter<RoutineState> emit) async {
    var routines = await _routineRepository.getAllRoutines();
    if (routines.isEmpty) {
      emit(LoadedAllRoutineState(routines));
      return;
    }

    var isReset = await _handleResetRoutineOnDayChange(routines.first, emit);
    if (!isReset) {
      emit(LoadedAllRoutineState(routines));
    }
  }

  Future<bool> _handleResetRoutineOnDayChange(Routine routine, Emitter<RoutineState> emit) async {
    var now = DateTime.now();
    // using the time of the first routine, because can compare only the full date time and not just the date.
    // We want to make the time identical between the next day and the first routine. Because
    // we don't want to reset the routines if the time is after the first routine time. Only the date is what
    // matters.
    var nextDayTime = DateTime(now.year, now.month, now.day, routine.time.hour, routine.time.minute);
    if (nextDayTime.isAfter(routine.time)) {
      var resetRoutines = await _routineRepository.resetAllRoutines();
      emit(LoadedAllRoutineState(resetRoutines));
      return true;
    } else {
      return false;
    }
  }

  FutureOr<void> _markCompleteRoutine(MarkCompleteRoutineEvent event, Emitter<RoutineState> emit) async {
    var routine = await _routineRepository.markRoutineComplete(event.id);
    if (routine != null) {
      emit(MarkedAsCompletedRoutineState(routine));
    }
    var allRoutines = await _routineRepository.getAllRoutines();
    emit(LoadedAllRoutineState(allRoutines));
  }

  FutureOr<void> _markIncompleteRoutine(MarkIncompleteRoutineEvent event, Emitter<RoutineState> emit) async {
    var routine = await _routineRepository.markRoutineIncomplete(event.id);
    if (routine != null) {
      emit(MarkedAsIncompleteRoutineState(routine));
    }
    var allRoutines = await _routineRepository.getAllRoutines();
    emit(LoadedAllRoutineState(allRoutines));
  }
}