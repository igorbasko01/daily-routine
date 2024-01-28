import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/repositories/in_memory_credits_repository.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_routine/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Welcome screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
        routineBloc: RoutineBloc(InMemoryRoutineRepository()),
        creditsBloc:
            CreditsBloc(repository: await InMemoryCreditsRepository.create())));

    expect(find.text('Welcome to your Daily Routine!'), findsOneWidget);
  });
}
