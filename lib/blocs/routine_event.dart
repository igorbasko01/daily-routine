import 'package:daily_routine/models/routine.dart';

sealed class RoutineEvent {}

class LoadAllRoutineEvent extends RoutineEvent {}

class AddRoutineEvent extends RoutineEvent {
  final Routine routine;

  AddRoutineEvent(this.routine);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddRoutineEvent &&
      other.routine == routine;
  }

  @override
  int get hashCode => routine.hashCode;
}

class UpdateRoutineEvent extends RoutineEvent {
  final Routine routine;

  UpdateRoutineEvent(this.routine);
}

class DeleteRoutineEvent extends RoutineEvent {
  final int id;

  DeleteRoutineEvent(this.id);
}

class ResetAllRoutineEvent extends RoutineEvent {}

class HandleDayChangeRoutineEvent extends RoutineEvent {}

class MarkCompleteRoutineEvent extends RoutineEvent {
  final int id;

  MarkCompleteRoutineEvent(this.id);
}

class MarkIncompleteRoutineEvent extends RoutineEvent {
  final int id;

  MarkIncompleteRoutineEvent(this.id);
}