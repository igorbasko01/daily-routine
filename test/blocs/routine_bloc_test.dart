import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
