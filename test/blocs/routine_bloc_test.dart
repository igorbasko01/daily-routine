import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
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
}
