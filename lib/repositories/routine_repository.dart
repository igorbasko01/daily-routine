import 'package:daily_routine/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getAllRoutines();
  Future<List<Routine>> addRoutine(Routine routine);
  Future<List<Routine>> updateRoutine(Routine routine);
  Future<List<Routine>> deleteRoutine(int id);
  Future<void> saveRoutines(List<Routine> routines);
  Future<List<Routine>> loadRoutines();
}

class RoutineNotFoundException implements Exception {
  final String message;
  RoutineNotFoundException(this.message);

  @override
  String toString() => 'RoutineNotFoundException: $message';
}