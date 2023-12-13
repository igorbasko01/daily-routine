import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_routine/main.dart';

void main() {
  testWidgets('Welcome screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(routineBloc: RoutineBloc(InMemoryRoutineRepository()),));

    expect(find.text('Welcome to your Daily Routine!'), findsOneWidget);
  });
}
