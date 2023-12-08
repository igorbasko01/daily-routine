import 'dart:math';

import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/routine_repository.dart';

class InMemoryRoutineRepository implements RoutineRepository {
  final List<Routine> _routines;

  InMemoryRoutineRepository({List<Routine>? initialRoutines})
      : _routines = initialRoutines ?? [];

  @override
  Future<List<Routine>> getAllRoutines() async {
    return _routines;
  }

  @override
  Future<List<Routine>> addRoutine(Routine routine) async {
    final newId =
        (_routines.isEmpty) ? 1 : (_routines.map((e) => e.id).reduce(max) + 1);
    final newRoutine = routine.copyWith(id: newId);
    _routines.add(newRoutine);
    return _routines;
  }

  /// Updates a routine in the repository.
  /// Throws a [RoutineNotFoundException] if the routine is not found.
  @override
  Future<List<Routine>> updateRoutine(Routine routine) async {
    final index = _routines.indexWhere((element) => element.id == routine.id);
    if (index == -1) {
      throw RoutineNotFoundException('Routine with id ${routine.id} not found');
    }
    _routines[index] = routine;
    return _routines;
  }

  /// Deletes a routine from the repository.
  /// Throws a [RoutineNotFoundException] if the routine is not found.
  @override
  Future<List<Routine>> deleteRoutine(int id) async {
    final index = _routines.indexWhere((element) => element.id == id);
    if (index == -1) {
      throw RoutineNotFoundException('Routine with id $id not found');
    }
    _routines.removeAt(index);
    return _routines;
  }
}
