import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/repositories/in_memory_routine_repository.dart';
import 'package:daily_routine/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var routineRepository = InMemoryRoutineRepository();
  await routineRepository.initialize();
  runApp(MyApp(routineRepository: routineRepository));
}

class MyApp extends StatelessWidget {
  final InMemoryRoutineRepository routineRepository;
  const MyApp({Key? key, required this.routineRepository}) : super(key: key);

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
            var bloc = RoutineBloc(routineRepository);
            bloc.add(LoadAllRoutineEvent());
            return bloc;
          },
          child: const HomePage(),
        ));
  }
}
