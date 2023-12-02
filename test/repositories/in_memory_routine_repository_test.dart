import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('In Memory Routine Repository Test', () {
    test('returns empty list when no routines are added', () async {
      final repository = InMemoryRoutineRepository();
      final routines = await repository.getAllRoutines();
      expect(routines, []);
    });

    test('returns all routines when routines are added', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine);
      final routines = await repository.getAllRoutines();
      expect(routines, [routine]);
    });

    test('Adding a routine with an existing id ignores the routine and adds it with a new id', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine1 = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      final routine2 = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine1);
      await repository.addRoutine(routine2);
      final routines = await repository.getAllRoutines();
      expect(routines, [routine1, routine2.copyWith(id: 2)]);
    });

    test('Adding a routine returns the routine with the new id', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine1 = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      final routine2 = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      final addedRoutine1 = await repository.addRoutine(routine1);
      final addedRoutine2 = await repository.addRoutine(routine2);
      expect(addedRoutine1, routine1);
      expect(addedRoutine2, routine2.copyWith(id: 2));
    });

    test('Updating a routine updates the routine', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine);
      final updatedRoutine = Routine(id: 1, name: 'Morning Exercise', time: dateTime, isCompleted: true);
      await repository.updateRoutine(updatedRoutine);
      final routines = await repository.getAllRoutines();
      expect(routines, [updatedRoutine]);
    });

    test('Updating a routine that does not exist throws a not found exception', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine);
      final updatedRoutine = Routine(id: 2, name: 'Morning Exercise', time: dateTime, isCompleted: true);
      expect(() => repository.updateRoutine(updatedRoutine), throwsA(isA<RoutineNotFoundException>()));
    });

    test('Deleting a routine removes the routine', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine);
      await repository.deleteRoutine(routine.id);
      final routines = await repository.getAllRoutines();
      expect(routines, []);
    });

    test('Deleting a routine that does not exist throws a not found exception', () async {
      final repository = InMemoryRoutineRepository();
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);
      await repository.addRoutine(routine);
      expect(() => repository.deleteRoutine(2), throwsA(isA<RoutineNotFoundException>()));
    });
  });
}