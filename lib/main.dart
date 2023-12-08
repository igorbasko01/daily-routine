import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Daily Routine',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) {
            var bloc = RoutineBloc(InMemoryRoutineRepository(initialRoutines: [
              Routine(
                  id: 1,
                  name: 'Morning Exercise',
                  time: DateTime(2023, 11, 30, 8, 0))
            ]));
            bloc.add(LoadAllRoutineEvent());
            return bloc;
          },
          child: const HomePage(),
        ));
  }
}
