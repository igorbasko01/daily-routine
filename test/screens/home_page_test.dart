import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRoutineBloc extends MockBloc<RoutineEvent, RoutineState>
    implements RoutineBloc {}

void main() {
  MockRoutineBloc? mockRoutineBloc;

  setUp(() {
    mockRoutineBloc = MockRoutineBloc();
  });

  tearDown(() {
    mockRoutineBloc?.close();
  });

  testWidgets(
      'Main Home Page has a title and a welcome message when no routines',
      (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));
    var titleFinder = find.text('Daily Routine');
    var welcomeFinder =
        find.text('Welcome to your Daily Routine! Please add some routines.');
    expect(titleFinder, findsOneWidget);
    expect(welcomeFinder, findsOneWidget);
  });
}
