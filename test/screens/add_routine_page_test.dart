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

  testWidgets('page contains a field for entering name of routine',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const AddRoutinePage(),
      ),
    ));
    var nameFinder = find.byKey(const Key('routineName'));
    expect(nameFinder, findsOneWidget);
  });

  testWidgets('page contains a field for selecting time of routine',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const AddRoutinePage(),
      ),
    ));
    var timeFinder = find.byKey(const Key('routineTime'));
    expect(timeFinder, findsOneWidget);
  });

  testWidgets('page contains a button for adding the routine',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const AddRoutinePage(),
      ),
    ));
    var addButtonFinder = find.byKey(const Key('addRoutineButton'));
    expect(addButtonFinder, findsOneWidget);
  });

  testWidgets('pressing the addRoutineButton sends an AddRoutineEvent',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const AddRoutinePage(),
      ),
    ));
    var nameFinder = find.byKey(const Key('routineName'));
    await widgetTester.enterText(nameFinder, 'Morning Exercise');
    var addButtonFinder = find.byKey(const Key('addRoutineButton'));
    await widgetTester.tap(addButtonFinder);
    var testDate = DateTime.now();
    var expectedRoutine = Routine(
        id: 1,
        name: 'Morning Exercise',
        time: DateTime(testDate.year, testDate.month, testDate.day, 8, 0));
    verify(() => mockRoutineBloc!.add(AddRoutineEvent(expectedRoutine)))
        .called(1);
  });

  testWidgets('pressing the addRoutineButton navigates to the HomePage',
      (widgetTester) async {
    when(() => mockRoutineBloc?.state).thenReturn(LoadedAllRoutineState([]));
    // start from home page to see that the navigation from AddRoutinePage
    // is actually navigates back to the home page.
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<RoutineBloc>.value(
        value: mockRoutineBloc!,
        child: const HomePage(),
      ),
    ));
    var homeAddButtonFinder = find.byKey(const Key('addRoutineButton'));
    await widgetTester.tap(homeAddButtonFinder);
    await widgetTester.pumpAndSettle();
    var nameFinder = find.byKey(const Key('routineName'));
    await widgetTester.enterText(nameFinder, 'Morning Exercise');
    var addButtonFinder = find.byKey(const Key('addRoutineButton'));
    await widgetTester.tap(addButtonFinder);
    await widgetTester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
