import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
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
              child: _listOfRoutines(state.routines),
            );
          }
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        key: const Key('addRoutineButton'),
        onPressed: () {
          Navigator.pushNamed(context, '/addRoutine');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _listOfRoutines(List<Routine> routines) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        var routine = routines[index];
        return ListTile(
          leading: Checkbox(
            key: const Key('checkButton'),
            value: routine.isCompleted,
            onChanged: (value) {
              BlocProvider.of<RoutineBloc>(context).add(
                  UpdateRoutineEvent(routine.toggleCompleted()));
            },
          ),
          title: Text(routines[index].name),
          subtitle: Text(routines[index].time.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: const Key('editButton'),
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/editRoutine',
                      arguments: routine);
                },
              ),
              IconButton(
                key: const Key('deleteButton'),
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<RoutineBloc>(context)
                      .add(DeleteRoutineEvent(routine.id));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
