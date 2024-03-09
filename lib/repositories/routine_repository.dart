import 'package:daily_routine/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getAllRoutines();
  Future<void> addRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine);
  Future<void> deleteRoutine(int id);
  Future<void> resetAllRoutines();
  Future<Routine?> markRoutineComplete(int id);
  Future<Routine?> markRoutineIncomplete(int id);
}

class RoutineNotFoundException implements Exception {
  final String message;
  RoutineNotFoundException(this.message);

  @override
  String toString() => 'RoutineNotFoundException: $message';
}