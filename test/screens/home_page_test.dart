import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/screens/add_routine_page.dart';
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

  testWidgets('Show a list of single routine', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var routineFinder = find.text('Morning Exercise');
    expect(routineFinder, findsOneWidget);
  });

  testWidgets('Show a list of multiple routines', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0)),
      Routine(id: 2, name: 'Afternoon Exercise', time: DateTime(2023, 11, 30, 13, 0)),
      Routine(id: 3, name: 'Evening Exercise', time: DateTime(2023, 11, 30, 18, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var morningRoutineFinder = find.text('Morning Exercise');
    var afternoonRoutineFinder = find.text('Afternoon Exercise');
    var eveningRoutineFinder = find.text('Evening Exercise');
    expect(morningRoutineFinder, findsOneWidget);
    expect(afternoonRoutineFinder, findsOneWidget);
    expect(eveningRoutineFinder, findsOneWidget);
  });

  testWidgets('a routine has a check button', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var routineFinder = find.text('Morning Exercise');
    expect(routineFinder, findsOneWidget);
    var checkButtonFinder = find.byKey(const Key('checkButton'));
    expect(checkButtonFinder, findsOneWidget);
  });

  testWidgets('a routine has an edit button', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var routineFinder = find.text('Morning Exercise');
    expect(routineFinder, findsOneWidget);
    var editButtonFinder = find.byKey(const Key('editButton'));
    expect(editButtonFinder, findsOneWidget);
  });

  testWidgets('a routine has a delete button', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var routineFinder = find.text('Morning Exercise');
    expect(routineFinder, findsOneWidget);
    var deleteButtonFinder = find.byKey(const Key('deleteButton'));
    expect(deleteButtonFinder, findsOneWidget);
  });

  testWidgets('the page has a floating button for adding routines when there are no routines', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var floatingButtonFinder = find.byKey(const Key('addRoutineButton'));
    expect(floatingButtonFinder, findsOneWidget);
  });

  testWidgets('the page has a floating button for adding routines when there are routines', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([
      Routine(id: 1, name: 'Morning Exercise', time: DateTime(2023, 11, 30, 8, 0))
    ]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var floatingButtonFinder = find.byKey(const Key('addRoutineButton'));
    expect(floatingButtonFinder, findsOneWidget);
  });

  testWidgets('pressing the addRoutineButton navigates to the AddRoutinePage', (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([]));

    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));

    var floatingButtonFinder = find.byKey(const Key('addRoutineButton'));
    expect(floatingButtonFinder, findsOneWidget);
    await widgetTester.tap(floatingButtonFinder);
    await widgetTester.pumpAndSettle();
    expect(find.byType(AddRoutinePage), findsOneWidget);
  });
}
