import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<RoutineBloc, RoutineState>(
    'emits empty list when no routines were added',
    build: () => RoutineBloc(InMemoryRoutineRepository()),
    act: (bloc) => bloc.add(LoadAllRoutineEvent()),
    expect: () => [
      predicate<LoadedAllRoutineState>((state) {
        return state.routines.isEmpty;
      }),
    ],
  );

  group('adding a routine', () {
    blocTest<RoutineBloc, RoutineState>(
        'adding a routine emits a LoadedAllRoutineState with the routine',
        build: () => RoutineBloc(InMemoryRoutineRepository()),
        act: (bloc) => bloc.add(AddRoutineEvent(Routine(
            id: 1,
            name: 'Morning Exercise',
            time: DateTime(2023, 11, 30, 8, 0)))),
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 1 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time == DateTime(2023, 11, 30, 8, 0);
              }),
            ]);

    blocTest('Adding a routine with an existing Id adds it with a new id',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0))
            ])),
        act: (bloc) {
          bloc.add(AddRoutineEvent(Routine(
              id: 1,
              name: 'Morning Exercise',
              time: DateTime(2023, 11, 30, 8, 0))));
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 2 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time == DateTime(2023, 11, 30, 8, 0) &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Morning Exercise' &&
                    state.routines[1].time == DateTime(2023, 11, 30, 8, 0);
              }),
            ]);
  });

  group('updating a routine', () {
    blocTest<RoutineBloc, RoutineState>(
        'updating a routine emits a LoadedAllRoutineState with the updated routine',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0))
            ])),
        act: (bloc) {
          bloc.add(UpdateRoutineEvent(Routine(
              id: 1,
              name: 'Morning Exercise',
              time: DateTime(2023, 11, 30, 8, 0),
              isCompleted: true)));
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 1 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time == DateTime(2023, 11, 30, 8, 0) &&
                    state.routines[0].isCompleted;
              }),
            ]);

    blocTest<RoutineBloc, RoutineState>(
      'updating a routine that does not exist emits an Error RoutineNotFoundState',
      build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
        Routine(
            id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
      ])),
      act: (bloc) {
        bloc.add(UpdateRoutineEvent(Routine(
            id: 2,
            name: 'Morning Exercise',
            time: DateTime(2023, 11, 30, 8, 0),
            isCompleted: true)));
      },
      expect: () => [
        predicate<ErrorRoutineState>((state) {
          return state.exception is RoutineNotFoundException;
        }),
      ],
    );
  });

  group('deleting a routine', () {
    blocTest(
      'deleting a routine emits a LoadedAllRoutineState without the deleted routine',
      build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
        Routine(
            id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
      ])),
      act: (bloc) {
        bloc.add(DeleteRoutineEvent(1));
      },
      expect: () => [
        predicate<LoadedAllRoutineState>((state) {
          return state.routines.isEmpty;
        }),
      ],
    );

    blocTest(
      'deleting a routine that does not exist emits an Error RoutineNotFoundState',
      build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
        Routine(
            id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
      ])),
      act: (bloc) {
        bloc.add(DeleteRoutineEvent(2));
      },
      expect: () => [
        predicate<ErrorRoutineState>((state) {
          return state.exception is RoutineNotFoundException;
        }),
      ],
    );
  });

  group('Resetting all the routines', () {
    blocTest('Resetting all the routines unchecks their isCompleted property',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(ResetAllRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 3 &&
                    !state.routines[0].isCompleted &&
                    !state.routines[1].isCompleted &&
                    !state.routines[2].isCompleted;
              }),
            ]);

    blocTest(
        'Resetting all the routines when no routines were added emits an empty list',
        build: () => RoutineBloc(InMemoryRoutineRepository()),
        act: (bloc) {
          bloc.add(ResetAllRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.isEmpty;
              }),
            ]);

    blocTest('Resetting all the routines updates their dates to today',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(ResetAllRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                var now = DateTime.now();
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time.year == now.year &&
                    state.routines[0].time.month == now.month &&
                    state.routines[0].time.day == now.day &&
                    !state.routines[0].isCompleted &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    state.routines[1].time.year == now.year &&
                    state.routines[1].time.month == now.month &&
                    state.routines[1].time.day == now.day &&
                    !state.routines[1].isCompleted &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    state.routines[2].time.year == now.year &&
                    state.routines[2].time.month == now.month &&
                    state.routines[2].time.day == now.day &&
                    !state.routines[2].isCompleted;
              }),
            ]);

    blocTest('Resetting all the routines leaves the time part as before',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(ResetAllRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                var now = DateTime.now();
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time.year == now.year &&
                    state.routines[0].time.month == now.month &&
                    state.routines[0].time.day == now.day &&
                    !state.routines[0].isCompleted &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    state.routines[1].time.year == now.year &&
                    state.routines[1].time.month == now.month &&
                    state.routines[1].time.day == now.day &&
                    !state.routines[1].isCompleted &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    state.routines[2].time.year == now.year &&
                    state.routines[2].time.month == now.month &&
                    state.routines[2].time.day == now.day &&
                    !state.routines[2].isCompleted;
              }),
            ]);
  });

  group('Handle day change', () {
    blocTest('Handle day change updates the date of the routines',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(HandleDayChangeRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                var now = DateTime.now();
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time.year == now.year &&
                    state.routines[0].time.month == now.month &&
                    state.routines[0].time.day == now.day &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    state.routines[1].time.year == now.year &&
                    state.routines[1].time.month == now.month &&
                    state.routines[1].time.day == now.day &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    state.routines[2].time.year == now.year &&
                    state.routines[2].time.month == now.month &&
                    state.routines[2].time.day == now.day;
              }),
            ]);

    blocTest('Handle day change does not update the time of the routines',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(HandleDayChangeRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                var now = DateTime.now();
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].time.year == now.year &&
                    state.routines[0].time.month == now.month &&
                    state.routines[0].time.day == now.day &&
                    state.routines[0].time.hour == 8 &&
                    state.routines[0].time.minute == 0 &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    state.routines[1].time.year == now.year &&
                    state.routines[1].time.month == now.month &&
                    state.routines[1].time.day == now.day &&
                    state.routines[1].time.hour == 13 &&
                    state.routines[1].time.minute == 0 &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    state.routines[2].time.year == now.year &&
                    state.routines[2].time.month == now.month &&
                    state.routines[2].time.day == now.day &&
                    state.routines[2].time.hour == 18 &&
                    state.routines[2].time.minute == 0;
              }),
            ]);

    blocTest('Handle day change sets the isCompleted to false',
        build: () => RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0),
                  isCompleted: true),
              Routine(
                  id: 2,
                  name: 'Afternoon Exercise',
                  time: DateTime(2023, 11, 30, 13, 0),
                  isCompleted: true),
              Routine(
                  id: 3,
                  name: 'Evening Exercise',
                  time: DateTime(2023, 11, 30, 18, 0),
                  isCompleted: true)
            ])),
        act: (bloc) {
          bloc.add(HandleDayChangeRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    !state.routines[0].isCompleted &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    !state.routines[1].isCompleted &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    !state.routines[2].isCompleted;
              }),
            ]);

    blocTest(
        'Handle day change does not update the isCompleted if not day change',
        build: () {
          var now = DateTime.now();
          return RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
            Routine(
                id: 1,
                name: 'Morning Exercise',
                time: DateTime(now.year, now.month, now.day, 8, 0),
                isCompleted: true),
            Routine(
                id: 2,
                name: 'Afternoon Exercise',
                time: DateTime(now.year, now.month, now.day, 13, 0),
                isCompleted: true),
            Routine(
                id: 3,
                name: 'Evening Exercise',
                time: DateTime(now.year, now.month, now.day, 18, 0),
                isCompleted: true)
          ]));
        },
        act: (bloc) {
          bloc.add(HandleDayChangeRoutineEvent());
        },
        expect: () => [
              predicate<LoadedAllRoutineState>((state) {
                return state.routines.length == 3 &&
                    state.routines[0].id == 1 &&
                    state.routines[0].name == 'Morning Exercise' &&
                    state.routines[0].isCompleted &&
                    state.routines[1].id == 2 &&
                    state.routines[1].name == 'Afternoon Exercise' &&
                    state.routines[1].isCompleted &&
                    state.routines[2].id == 3 &&
                    state.routines[2].name == 'Evening Exercise' &&
                    state.routines[2].isCompleted;
              }),
            ]);
  });
}
