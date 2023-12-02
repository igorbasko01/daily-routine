import 'package:daily_routine/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getAllRoutines();
  Future<Routine> addRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine);
  Future<void> deleteRoutine(int id);
}

class RoutineNotFoundException implements Exception {
  final String message;
  RoutineNotFoundException(this.message);

  @override
  String toString() => 'RoutineNotFoundException: $message';
}