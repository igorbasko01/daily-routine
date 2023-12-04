import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
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
}
