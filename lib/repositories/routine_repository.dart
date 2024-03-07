import 'package:daily_routine/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getAllRoutines();
  Future<List<Routine>> addRoutine(Routine routine);
  Future<List<Routine>> updateRoutine(Routine routine);
  Future<List<Routine>> deleteRoutine(int id);
  Future<List<Routine>> resetAllRoutines();
  Future<Routine?> markRoutineComplete(int id);
}

class RoutineNotFoundException implements Exception {
  final String message;
  RoutineNotFoundException(this.message);

  @override
  String toString() => 'RoutineNotFoundException: $message';
}