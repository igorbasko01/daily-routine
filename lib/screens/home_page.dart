import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Routine'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          BlocBuilder<RoutineBloc, RoutineState>(builder: (blocContext, state) {
        if (state is InitialRoutineState) {
          return const Center(
            child: Text('Welcome to your Daily Routine!'),
          );
        } else if (state is LoadedAllRoutineState) {
          if (state.routines.isEmpty) {
            return const Center(
              child: Text(
                  'Welcome to your Daily Routine! Please add some routines.'),
            );
          } else {
            return Center(
              child: Text('You have ${state.routines.length} routines.'),
            );
          }
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      }),
    );
  }
}
