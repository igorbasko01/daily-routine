import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/credits_event.dart';
import 'package:daily_routine/blocs/credits_state.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/services/user_activity_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRoutineBloc extends MockBloc<RoutineEvent, RoutineState>
    implements RoutineBloc {}

class MockCreditsBloc extends MockBloc<CreditsEvent, CreditsState>
    implements CreditsBloc {}

void main() {
  MockRoutineBloc? mockRoutineBloc;
  MockCreditsBloc? mockCreditsBloc;

  setUp(() {
    mockRoutineBloc = MockRoutineBloc();
    mockCreditsBloc = MockCreditsBloc();
  });

  tearDown(() {
    mockRoutineBloc?.close();
    mockCreditsBloc?.close();
  });

  test('UserActivityManager should subscribe to routineBloc state', () {
    UserActivityManager(
        routineBloc: mockRoutineBloc!, creditsBloc: mockCreditsBloc!);
    verify(() => mockRoutineBloc!.stream);
  });

  test(
      'UserActivityManager should emit credits add when routine is marked as completed',
      () async {
    whenListen(
        mockRoutineBloc!,
        Stream.fromIterable([
          MarkedAsCompletedRoutineState(Routine(
              id: 1,
              name: 'Morning Exercise',
              time: DateTime(2023, 11, 30, 8, 0),
              credits: 5))
        ]));
    UserActivityManager(
        routineBloc: mockRoutineBloc!, creditsBloc: mockCreditsBloc!);
    await Future.delayed(const Duration(milliseconds: 10));
    verify(() => mockCreditsBloc!.add(AddCreditsEvent(5)));
  });

  test('UserActivityManager should emit credits withdraw when routine is marked as incomplete', () async {
    whenListen(
        mockRoutineBloc!,
        Stream.fromIterable([
          MarkedAsIncompleteRoutineState(Routine(
              id: 1,
              name: 'Morning Exercise',
              time: DateTime(2023, 11, 30, 8, 0),
              credits: 5))
        ]));
    UserActivityManager(
        routineBloc: mockRoutineBloc!, creditsBloc: mockCreditsBloc!);
    await Future.delayed(const Duration(milliseconds: 10));
    verify(() => mockCreditsBloc!.add(WithdrawCreditsEvent(5)));
  });
}
