import 'dart:convert';

import 'package:daily_routine/models/routine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Routine Model Test', () {
    test('Routine is correctly instantiated', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
    });

    test('Routine initializes with default credits', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
      expect(routine.credits, 3);
    });

    test('Routine initializes with specific credits', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine =
          Routine(id: 1, name: 'Morning Exercise', time: dateTime, credits: 5);

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
      expect(routine.credits, 5);
    });

    test('Routine throws exception if initializes with negative credits', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      expect(
          () => Routine(
              id: 1, name: 'Morning Exercise', time: dateTime, credits: -1),
          throwsAssertionError);
    });
  });

  group('Routine Model Json Serialization', () {
    test('Routine is correctly serialized to json', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime, credits: 3);

      expect(routine.toJson(), {
        'id': 1,
        'name': 'Morning Exercise',
        'time': dateTime.toIso8601String(),
        'isCompleted': false,
        'credits': 3
      });
    });

    test('Routine is correctly deserialized from json', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine.fromJson({
        'id': 1,
        'name': 'Morning Exercise',
        'time': dateTime.toIso8601String(),
        'isCompleted': false,
        'credits': 5
      });

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
      expect(routine.credits, 5);
    });

    test('Routine is correctly deserialized from json string', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      const jsonString =
          '{"id":1,"name":"Morning Exercise","time":"2023-11-30T08:00:00.000","isCompleted":false,"credits":2}';
      final jsonMap = jsonDecode(jsonString);
      final routine = Routine.fromJson(jsonMap);

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
      expect(routine.credits, 2);
    });

    test('Routine is correctly serialized to json string', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime, credits: 4);

      expect(jsonEncode(routine),
          '{"id":1,"name":"Morning Exercise","time":"2023-11-30T08:00:00.000","isCompleted":false,"credits":4}');
    });

    group('copyWith', () {
      test('Routine is correctly copied with new id', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime, credits: 4);
        final newRoutine = routine.copyWith(id: 2);

        expect(newRoutine.id, 2);
        expect(newRoutine.name, 'Morning Exercise');
        expect(newRoutine.time, dateTime);
        expect(newRoutine.isCompleted, false);
        expect(newRoutine.credits, 4);
      });

      test('Routine is correctly copied with new name', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime, credits: 4);
        final newRoutine = routine.copyWith(name: 'Evening Exercise');

        expect(newRoutine.id, 1);
        expect(newRoutine.name, 'Evening Exercise');
        expect(newRoutine.time, dateTime);
        expect(newRoutine.isCompleted, false);
        expect(newRoutine.credits, 4);
      });

      test('Routine is correctly copied with new time', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime);
        final newDateTime = DateTime(2023, 11, 30, 18, 0);
        final newRoutine = routine.copyWith(time: newDateTime);

        expect(newRoutine.id, 1);
        expect(newRoutine.name, 'Morning Exercise');
        expect(newRoutine.time, newDateTime);
        expect(newRoutine.isCompleted, false);
      });

      test('Routine is correctly copied with new isCompleted', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime);
        final newRoutine = routine.copyWith(isCompleted: true);

        expect(newRoutine.id, 1);
        expect(newRoutine.name, 'Morning Exercise');
        expect(newRoutine.time, dateTime);
        expect(newRoutine.isCompleted, true);
      });

      test('Routine is correctly copied with new credits', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime);
        final newRoutine = routine.copyWith(credits: 5);

        expect(newRoutine.id, 1);
        expect(newRoutine.name, 'Morning Exercise');
        expect(newRoutine.time, dateTime);
        expect(newRoutine.isCompleted, false);
        expect(newRoutine.credits, 5);
      });

      test('Routine is correctly copied with multiple new values', () {
        final dateTime = DateTime(2023, 11, 30, 8, 0);
        final routine =
            Routine(id: 1, name: 'Morning Exercise', time: dateTime);
        final newDateTime = DateTime(2023, 11, 30, 18, 0);
        final newRoutine = routine.copyWith(
            id: 2,
            name: 'Evening Exercise',
            time: newDateTime,
            isCompleted: true,
            credits: 5);

        expect(newRoutine.id, 2);
        expect(newRoutine.name, 'Evening Exercise');
        expect(newRoutine.time, newDateTime);
        expect(newRoutine.isCompleted, true);
        expect(newRoutine.credits, 5);
      });
    });
  });
}
