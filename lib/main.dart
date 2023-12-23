import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final RoutineBloc routineBloc;

  AppLifecycleObserver(this.routineBloc);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.detached) {
      routineBloc.add(HandleDayChangeRoutineEvent());
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var routineRepository = InMemoryRoutineRepository();
  await routineRepository.initialize();
  var routineBloc = RoutineBloc(routineRepository);
  var appLifecycleObserver = AppLifecycleObserver(routineBloc);
  WidgetsBinding.instance.addObserver(appLifecycleObserver);
  runApp(MyApp(routineBloc: routineBloc));
}

class MyApp extends StatelessWidget {
  final RoutineBloc routineBloc;

  const MyApp({Key? key, required this.routineBloc}) : super(key: key);

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
            routineBloc.add(LoadAllRoutineEvent());
            return routineBloc;
          },
          child: const HomePage(),
        ));
  }
}
