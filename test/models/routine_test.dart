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
  });

  group('Routine Model Json Serialization', () {
    test('Routine is correctly serialized to json', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine(id: 1, name: 'Morning Exercise', time: dateTime);

      expect(routine.toJson(), {
        'id': 1,
        'name': 'Morning Exercise',
        'time': dateTime.toIso8601String(),
        'isCompleted': false
      });
    });

    test('Routine is correctly deserialized from json', () {
      final dateTime = DateTime(2023, 11, 30, 8, 0);
      final routine = Routine.fromJson({
        'id': 1,
        'name': 'Morning Exercise',
        'time': dateTime.toIso8601String(),
        'isCompleted': false
      });

      expect(routine.id, 1);
      expect(routine.name, 'Morning Exercise');
      expect(routine.time, dateTime);
      expect(routine.isCompleted, false);
    });
  });

}