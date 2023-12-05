import 'package:daily_routine/models/routine.dart';

sealed class RoutineState {}

class InitialRoutineState extends RoutineState {}

class LoadedAllRoutineState extends RoutineState {
  final List<Routine> routines;

  LoadedAllRoutineState(this.routines);
}

class ErrorRoutineState extends RoutineState {
  final Exception exception;

  ErrorRoutineState(this.exception);
}