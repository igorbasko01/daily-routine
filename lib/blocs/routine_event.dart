import 'package:daily_routine/models/routine.dart';

sealed class RoutineEvent {}

class LoadAllRoutineEvent extends RoutineEvent {}

class AddRoutineEvent extends RoutineEvent {
  final Routine routine;

  AddRoutineEvent(this.routine);
}